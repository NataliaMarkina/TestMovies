//
//  PlanetViewController.swift
//  TestMovies
//
//  Created by Natalia on 15.05.2022.
//

import UIKit
import CoreData
import Stevia

class PlanetViewController: UIViewController {

    var planet: Planet? {
        didSet { fillData() }
    }

    var openedCharacter: Character?

    private lazy var nameLabel = UILabel().style(labelStyle)
    private lazy var diameterLabel = UILabel().style(labelStyle)
    private lazy var climateLabel = UILabel().style(labelStyle)
    private lazy var gravityLabel = UILabel().style(labelStyle)
    private lazy var terrainLabel = UILabel().style(labelStyle)
    private lazy var populationLabel = UILabel().style(labelStyle)

    private func labelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 16)
        l.numberOfLines = 0
    }

    private lazy var stackContainer = UIStackView().style(stackContainerStyle)
    private func stackContainerStyle(s: UIStackView) {
        s.axis = .vertical
        s.alignment = .leading
        s.distribution = .fillProportionally
        s.spacing = 8
        s.arrangedSubviews([
            nameLabel,
            diameterLabel,
            climateLabel,
            gravityLabel,
            terrainLabel,
            populationLabel
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupNavigationBar()
        setupSubviews()
        loadData()
    }

    private func setupNavigationBar() {
        setupTitleController(title: openedCharacter?.name)
        setupBackButton()
    }

    private func setupSubviews() {
        view.subviews(stackContainer)
        stackContainer.top(16).left(16).right(16)
    }

    private func loadData() {
        if let savedPlanet = getSavedData() {
            planet = savedPlanet
        } else {
            getPlanet()
        }
    }

    private func getPlanet() {
        startIndicatingActivity()

        ApiManager.shared.getPlanet(url: openedCharacter?.homeworld) { [weak self] planet in
            guard let self = self else { return }
            self.saveInCoreData(planetModel: planet)
            self.stopIndicatingActivity()
        } error: { _ in
            self.stopIndicatingActivity()
            self.showAlertError()
        }
    }

    private func fillData() {
        nameLabel.text = "Название планеты: \(planet?.name ?? "")"
        diameterLabel.text = "Диаметр планеты: \(planet?.diameter ?? "")"
        climateLabel.text = "Тип климата: \(planet?.climate ?? "")"
        gravityLabel.text = "Гравитация: \(planet?.gravity ?? "")"
        terrainLabel.text = "Тип местности: \(planet?.terrain ?? "")"
        populationLabel.text = "Население: \(planet?.population ?? "")"
    }

    private func getCurrentCharacter() -> Character? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Character.fetchRequest()
        let characters = try? context.fetch(fetchRequest)
        return characters?.first(where: { $0.name == openedCharacter?.name })
    }

    private func getSavedData() -> Planet? {
        guard let currentCharacter = getCurrentCharacter() else { return nil }
        return currentCharacter.planet
    }

    private func savePlanet(planetEntity: Planet) {
        guard let currentCharacter = getCurrentCharacter() else { return }

        currentCharacter.planet = planetEntity
        planet = planetEntity
    }

    private func createMovieEntity(planetModel: PlanetModel) -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext

        let planetEntity = Planet(context: context)
        planetEntity.name = planetModel.name
        planetEntity.rotationPeriod = planetModel.rotationPeriod
        planetEntity.orbitalPeriod = planetModel.orbitalPeriod
        planetEntity.diameter = planetModel.diameter
        planetEntity.climate = planetModel.climate
        planetEntity.gravity = planetModel.gravity
        planetEntity.terrain = planetModel.terrain
        planetEntity.surfaceWater = planetModel.surfaceWater
        planetEntity.population = planetModel.population
        planetEntity.residents = planetModel.residents
        planetEntity.films = planetModel.films
        planetEntity.created = planetModel.created
        planetEntity.edited = planetModel.edited
        planetEntity.url = planetModel.url

        return planetEntity
    }

    private func saveInCoreData(planetModel: PlanetModel?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let planetModel = planetModel
        else { return }
        let context = appDelegate.persistentContainer.viewContext

        guard let planetEntity = createMovieEntity(planetModel: planetModel) as? Planet else { return }
        savePlanet(planetEntity: planetEntity)

        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
}
