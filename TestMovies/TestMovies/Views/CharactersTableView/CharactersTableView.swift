//
//  CharactersTableView.swift
//  TestMovies
//
//  Created by Natalia on 14.05.2022.
//

import UIKit
import Stevia

protocol CharactersTableViewDelegate: AnyObject {
    func openPlanetInfo(currentCharacter: Character)
}

class CharactersTableView: UITableView {

    weak var viewDelegate: CharactersTableViewDelegate?

    var characters: [Character]? {
        didSet { reloadData() }
    }

    init(viewDelegate: CharactersTableViewDelegate?) {
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
        tableFooterView = UIView()
        register(CharactersTableViewCell.self, forCellReuseIdentifier: "characterCell")
    }
}

extension CharactersTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharactersTableViewCell else { return UITableViewCell() }
        cell.character = characters?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let character = characters?[indexPath.row] else { return }

        viewDelegate?.openPlanetInfo(currentCharacter: character)
    }
}
