//
//  MoviesTableView.swift
//  TestMovies
//
//  Created by Natalia on 14.05.2022.
//

import UIKit
import Stevia
import CoreData

protocol MoviesTableViewDelegate: AnyObject {
    func openCharacters(urls: [String])
}

class MoviesTableView: UITableView {

    weak var viewDelegate: MoviesTableViewDelegate?

    var searchedMovies: [Movie]? {
        didSet { reloadData() }
    }

    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult>? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Movie.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "episodeId", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()

    init(viewDelegate: MoviesTableViewDelegate?) {
        super.init(frame: .zero, style: .grouped)

        self.viewDelegate = viewDelegate
        configTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configTableView() {
        delegate = self
        dataSource = self

        backgroundColor = .white
        separatorStyle = .singleLine
        register(MoviesTableViewCell.self, forCellReuseIdentifier: "movieCell")
    }
}

extension MoviesTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovies?.count ?? fetchedhResultController?.sections?.first?.numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }
        if !(searchedMovies?.isEmpty ?? true) {
            cell.movie = searchedMovies?[indexPath.row]
        } else if let movie = fetchedhResultController?.object(at: indexPath) as? Movie {
            cell.movie = movie
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = fetchedhResultController?.object(at: indexPath) as? Movie,
              let characters = movie.characters
        else { return }

        viewDelegate?.openCharacters(urls: characters)
    }
}

extension MoviesTableView: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        endUpdates()
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        beginUpdates()
    }
}
