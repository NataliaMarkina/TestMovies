//
//  CharactersTableViewCell.swift
//  TestMovies
//
//  Created by Natalia on 14.05.2022.
//

import UIKit
import Stevia

class CharactersTableViewCell: UITableViewCell {

    var character: Character? {
        didSet { fillData() }
    }

    private lazy var nameLabel = UILabel().style(nameLabelStyle)
    private func nameLabelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 16, weight: .bold)
    }

    private lazy var genderLabel = UILabel().style(labelStyle)
    private lazy var birthYearLabel = UILabel().style(labelStyle)

    private func labelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 14)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        nameLabel.text = ""
        genderLabel.text = ""
        birthYearLabel.text = ""
    }

    private func setupSubviews() {
        subviews([
            nameLabel,
            genderLabel,
            birthYearLabel
        ])

        layout([
            6,
            |-16-nameLabel-16-|,
            4,
            |-16-genderLabel-16-|,
            4,
            |-16-birthYearLabel-16-|,
            6
        ])
    }

    private func fillData() {
        nameLabel.text = character?.name
        genderLabel.text = "Пол: \(character?.gender ?? "")"
        birthYearLabel.text = "Год рождения: \(character?.birthYear ?? "")"
    }
}
