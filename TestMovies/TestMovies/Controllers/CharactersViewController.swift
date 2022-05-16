//
//  CharactersViewController.swift
//  TestMovies
//
//  Created by Natalia on 14.05.2022.
//

import UIKit
import CoreData
import Stevia

class CharactersViewController: UIViewController {

    var charactersUrls: [String]? {
        didSet { loadData() }
    }

    var openedMovie: Movie?

    lazy var tableView = CharactersTableView(viewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavigationBar()
        setupSubviews()
        loadData()
    }

    private func setupNavigationBar() {
        setupTitleController(title: openedMovie?.title)
        setupBackButton()
    }

    private func setupSubviews() {
        view.subviews(tableView)
        tableView.fillContainer()
    }

    private func loadData() {
        let characters = getSavedData()

        if characters?.isEmpty ?? false {
            getCharacters()
        } else {
            tableView.characters = characters
        }
    }

    private func getCharacters() {
        startIndicatingActivity()

        ApiManager.shared.getCharacters(charactersUrls: charactersUrls) { [weak self] characters in
            guard let self = self else { return }
            self.saveInCoreData(characters: characters)
            self.stopIndicatingActivity()
        } error: { _ in
            self.stopIndicatingActivity()
            self.showAlertError()
        }
    }

    private func getCurrentMovie() -> Movie? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Movie.fetchRequest()
        let movies = try? context.fetch(fetchRequest)
        return movies?.first(where: { $0.episodeId == openedMovie?.episodeId })
    }

    private func getSavedData() -> [Character]? {
        guard let currentMovie = getCurrentMovie(),
              let characters = currentMovie.allCharacters?.allObjects as? [Character]
        else { return nil }

        return characters
    }

    private func saveCharacters(charactersEntities: [Character]) {
        guard let currentMovie = getCurrentMovie() else { return }

        currentMovie.allCharacters = NSSet.init(array: charactersEntities)
        tableView.characters = charactersEntities
    }

    private func createMovieEntity(characterModel: CharacterModel) -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext

        let characterEntity = Character(context: context)
        characterEntity.name = characterModel.name
        characterEntity.height = characterModel.height
        characterEntity.mass = characterModel.mass
        characterEntity.hairColor = characterModel.hairColor
        characterEntity.skinColor = characterModel.skinColor
        characterEntity.eyeColor = characterModel.eyeColor
        characterEntity.birthYear = characterModel.birthYear
        characterEntity.gender = characterModel.gender
        characterEntity.homeworld = characterModel.homeworld
        characterEntity.films = characterModel.films
        characterEntity.species = characterModel.species
        characterEntity.vehicles = characterModel.vehicles
        characterEntity.starships = characterModel.starships
        characterEntity.created = characterModel.created
        characterEntity.edited = characterModel.edited
        characterEntity.url = characterModel.url

        return characterEntity
    }

    private func saveInCoreData(characters: [CharacterModel]?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let characters = characters
        else { return }
        let context = appDelegate.persistentContainer.viewContext

        guard let charactersEntities = characters.map({ createMovieEntity(characterModel: $0) }) as? [Character] else { return }
        saveCharacters(charactersEntities: charactersEntities)

        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
}

extension CharactersViewController: CharactersTableViewDelegate {
    func openPlanetInfo(currentCharacter: Character) {
        let planetVC = PlanetViewController()
        planetVC.openedCharacter = currentCharacter
        navigationController?.pushViewController(planetVC, animated: true)
    }
}
