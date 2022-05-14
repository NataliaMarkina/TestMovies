//
//  MoviesTableViewCell.swift
//  TestMovies
//
//  Created by Natalia on 14.05.2022.
//

import UIKit
import Stevia

class MoviesTableViewCell: UITableViewCell {

    var movie: Movie? {
        didSet { fillData() }
    }

    private lazy var titleLabel = UILabel().style(titleLabelStyle)
    private func titleLabelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 16, weight: .bold)
    }

    private lazy var directorLabel = UILabel().style(directorLabelStyle)
    private func directorLabelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 14)
    }

    private lazy var producerLabel = UILabel().style(producerLabelStyle)
    private func producerLabelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 14)
    }

    private lazy var releaseDateLabel = UILabel().style(releaseDateLabelStyle)
    private func releaseDateLabelStyle(l: UILabel) {
        l.textColor = .red
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
        titleLabel.text = ""
        directorLabel.text = ""
        producerLabel.text = ""
        releaseDateLabel.text = ""
    }

    private func setupSubviews() {
        subviews([
            titleLabel,
            directorLabel,
            producerLabel,
            releaseDateLabel
        ])

        layout([
            6,
            |-titleLabel-|,
            4,
            |-directorLabel-|,
            4,
            |-producerLabel-|,
            4,
            |-releaseDateLabel-|,
            6
        ])
    }

    private func fillData() {
        titleLabel.text = movie?.title
        directorLabel.text = movie?.director
        producerLabel.text = movie?.producer
        releaseDateLabel.text = movie?.releaseDate
    }
}
