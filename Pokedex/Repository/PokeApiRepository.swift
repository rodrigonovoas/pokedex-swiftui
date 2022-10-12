//
//  PokeApiRepository.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 12/10/22.
//

import Foundation
import Combine

protocol PokeApiRepositoryProtocol {
    func getPokemonsFromAPI(pokemonCompletitionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void)
    func getPokemonDetailByNameFromAPI(pokemon: String, pokemonDetailCompletitionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void)
}

// MARK: - Implemetation

struct PokeApiRepository: PokeApiRepositoryProtocol {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getPokemonsFromAPI(pokemonCompletitionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void) {
        guard let url = URL(string: baseURL + "/pokemon?limit=13&offset=0") else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedPokes = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                        let pokemonsList = decodedPokes.results!
                        
                        for i in 1...pokemonsList.count - 1 {
                            self.getPokemonDetailByNameFromAPI(pokemon: pokemonsList[i].name , pokemonDetailCompletitionHandler: { pokemon, error in
                                if let pokemon = pokemon {
                                    pokemonCompletitionHandler(pokemon, nil)
                                }
                            })
                        }
                    } catch let error {
                        print("Error decoding: ", error)
                        pokemonCompletitionHandler(nil, error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }

    func getPokemonDetailByNameFromAPI(pokemon: String, pokemonDetailCompletitionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void) {
        guard let url = URL(string: baseURL + "/pokemon/\(pokemon)") else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let pokemonDetail = try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
                        pokemonDetailCompletitionHandler(pokemonDetail, nil)
                    } catch let error {
                        pokemonDetailCompletitionHandler(nil, error)
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
}


// MARK: - API
/*
extension RealCountriesWebRepository {
    enum API: APICall {
        case allCountries
        case countryDetails(Country)
        
        var path: String { ... }
        var httpMethod: String { ... }
        var headers: [String: String]? { ... }
    }
}
 */
