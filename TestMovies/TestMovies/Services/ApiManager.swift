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

    func getCharacters(charactersUrls: [String]?, completed: @escaping ([CharacterModel])->(), error: @escaping (AFError)->()) {
        guard let charactersUrls = charactersUrls else { return }
        var characters: [CharacterModel] = []
        let dispatchGroup = DispatchGroup()

        for url in charactersUrls {
            dispatchGroup.enter()
            AF.request(url)
                .responseDecodable(of: CharacterModel.self) { response in
                    switch response.result {
                    case .success(let character):
                        characters.append(character)
                        dispatchGroup.leave()
                    case .failure(let errorDescription):
                        error(errorDescription)
                    }
                }
        }

        dispatchGroup.notify(queue: .main) {
            completed(characters)
        }

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
