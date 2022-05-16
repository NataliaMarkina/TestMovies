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

    private lazy var directorLabel = UILabel().style(labelStyle)
    private lazy var producerLabel = UILabel().style(labelStyle)

    private func labelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 14)
        l.numberOfLines = 0
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
            |-16-titleLabel-16-|,
            4,
            |-16-directorLabel-16-|,
            4,
            |-16-producerLabel-16-|,
            4,
            |-16-releaseDateLabel-16-|,
            6
        ])
    }

    private func fillData() {
        titleLabel.text = movie?.title
        directorLabel.text = "Директор: \(movie?.director ?? "")"
        producerLabel.text = "Продюссеры: \(movie?.producer ?? "")"
        releaseDateLabel.text = movie?.releaseDate
    }
}
