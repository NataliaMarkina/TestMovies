//
//  ApiManager.swift
//  TestMovies
//
//  Created by Natalia on 14.05.2022.
//

import Alamofire

class ApiManager {
    static var shared = ApiManager()

    func getMovies(completed: @escaping ([MovieModel])->(), error: @escaping (AFError)->()) {
        let url = "https://swapi.dev/api/films/"

        AF.request(url)
            .responseDecodable(of: MoviesResponse.self) { response in
                switch response.result {
                case .success(let moviesResponse):
                    guard let movies = moviesResponse.results else { return }
                    completed(movies)
                case .failure(let errorDescription):
                    error(errorDescription)
                }
            }
    }

    func getCharacters(urlsCharacters: [String]?, completed: @escaping ([CharacterModel])->(), error: @escaping (AFError)->()) {
        guard let urlsCharacters = urlsCharacters else { return }
        var characters: [CharacterModel] = []

        for url in urlsCharacters {
            AF.request(url)
                .responseDecodable(of: CharacterModel.self) { response in
                    switch response.result {
                    case .success(_):
                        guard let character = response.value else { return }
                        characters.append(character)
                    case .failure(let errorDescription):
                        error(errorDescription)
                    }
                }
        }

        completed(characters)
    }

    func getPlanet(url: String?, completed: @escaping (PlanetModel)->(), error: @escaping (AFError)->()) {
        guard let url = url else { return }

        AF.request(url)
            .responseDecodable(of: PlanetModel.self) { response in
                switch response.result {
                case .success(_):
                    guard let planet = response.value else { return }
                    completed(planet)
                case .failure(let errorDescription):
                    error(errorDescription)
                }
            }
    }
}
