//
//  ViewController.swift
//  TestMovies
//
//  Created by Natalia on 14.05.2022.
//

import UIKit
import CoreData
import Stevia

class MainViewController: UIViewController {

    var searchedMovies: [Movie]? {
        didSet { tableView.searchedMovies = searchedMovies }
    }

    lazy var tableView = MoviesTableView(viewDelegate: self)

    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Название фильма"
        definesPresentationContext = true
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.searchController = searchController
        setupSubviews()
        loadData()
    }

    private func setupSubviews() {
        view.subviews(tableView)
        tableView.fillContainer()
    }

    private func loadData() {
        do {
            try tableView.fetchedhResultController?.performFetch()
        } catch let error  {
            print("ERROR: \(error)")
        }

        if isEmptySavedData() {
            ApiManager.shared.getMovies { [weak self] movies in
                guard let self = self else { return }
                self.saveInCoreData(movies: movies)
            } error: { error in
                return
            }
        }
    }

    private func isEmptySavedData() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return true }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Movie.fetchRequest()
        let objects = try? context.fetch(fetchRequest)
        return objects?.isEmpty ?? true
    }

    private func createMovieEntity(movieModel: MovieModel) -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext

        let movieEntity = Movie(context: context)
        movieEntity.title = movieModel.title
        movieEntity.episodeId = Int32(movieModel.episodeId)
        movieEntity.openingCrawl = movieModel.openingCrawl
        movieEntity.director = movieModel.director
        movieEntity.producer = movieModel.producer
        movieEntity.releaseDate = movieModel.releaseDate
        movieEntity.characters = movieModel.characters
        movieEntity.planets = movieModel.planets
        movieEntity.starships = movieModel.starships
        movieEntity.vehicles = movieModel.vehicles
        movieEntity.species = movieModel.species
        movieEntity.created = movieModel.created
        movieEntity.edited = movieModel.edited
        movieEntity.url = movieModel.url

        return movieEntity
    }

    private func saveInCoreData(movies: [MovieModel]?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let movies = movies
        else { return }
        let context = appDelegate.persistentContainer.viewContext

        _ = movies.map { createMovieEntity(movieModel: $0) }

        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
}

extension MainViewController: MoviesTableViewDelegate {
    func openCharacters(urls: [String], currentMovie: Movie?) {
        let charactersVC = CharactersViewController()
        charactersVC.charactersUrls = urls
        charactersVC.openedMovie = currentMovie
        navigationController?.pushViewController(charactersVC, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let searchText = searchController.searchBar.text
        else { return }
        let context = appDelegate.persistentContainer.viewContext

        if !searchText.isEmpty {
            let predicate = NSPredicate(format: "title contains[c] '\(searchText)'")
            let fetchRequest = Movie.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                searchedMovies = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        } else {
            searchedMovies = nil
        }
    }
}
