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
    func openCharacters(urls: [String], currentMovie: Movie?)
}

class MoviesTableView: UITableView {

    weak var viewDelegate: MoviesTableViewDelegate?

    var movies: [Movie]? {
        didSet { reloadData() }
    }

    init(viewDelegate: MoviesTableViewDelegate?) {
        super.init(frame: .zero, style: .plain)

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
        showsVerticalScrollIndicator = false
        tableFooterView = UIView()
        register(MoviesTableViewCell.self, forCellReuseIdentifier: "movieCell")
    }
}

extension MoviesTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }
        cell.movie = movies?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movies?[indexPath.row],
              let characters = movie.characters
        else { return }

        viewDelegate?.openCharacters(urls: characters, currentMovie: movie)
    }
}
