//
//  MoviesResponse.swift
//  TestMovies
//
//  Created by Natalia on 14.05.2022.
//

struct MoviesResponse: Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [MovieModel]?
}
