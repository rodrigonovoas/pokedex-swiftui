//
//  PokeApiRepository.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 12/10/22.
//

import Foundation
import Combine

struct PokeApiRepository: PokeApiRepositoryProtocol {
    private let baseURL: String = "https://pokeapi.co/api/v2"
    let session: URLSession
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getPokemonsFromAPI(pokemonCompletitionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void) {
        guard let url = URL(string: baseURL + PokeApiEndpoints.pokemonList.rawValue + "?limit=13&offset=0") else { fatalError("Missing URL") }
        
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
        guard let url = URL(string: baseURL + PokeApiEndpoints.pokemonDetail.rawValue + "\(pokemon)") else { fatalError("Missing URL") }
        
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
    
    func getPokemonDescriptionFromAPI(endpoint: String, pokemonDescriptionCompletitionHandler: @escaping (PokemonSpecieResponse?, Error?) -> Void) {
        guard let url = URL(string: endpoint) else { fatalError("Missing URL") }
        
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
                        let pokemonSpecieDetail = try JSONDecoder().decode(PokemonSpecieResponse.self, from: data)
                        pokemonDescriptionCompletitionHandler(pokemonSpecieDetail, nil)
                    } catch let error {
                        pokemonDescriptionCompletitionHandler(nil, error)
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
}
