//
//  PokeApiRepository.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 12/10/22.
//

import Foundation
import Combine
import RxSwift

struct PokeApiRepository: PokeApiRepositoryProtocol {
    private let baseURL: String = "https://pokeapi.co/api/v2"
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getPokemonsFromAPI(from: Int) -> Observable<[Pokemon]> {
        return Observable<[Pokemon]>.create { observer in
            let getPokemonsBaseUrl = baseURL + PokeApiEndpoints.pokemonList.rawValue
            let urlEndpoint = getPokemonsBaseUrl + "?limit=12&offset="+from.description
            
            guard let url = URL(string: urlEndpoint) else {
                return Disposables.create()
                // fatalError("Missing URL")
            }
            
            let urlRequest = URLRequest(url: url)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else { return }
                
                if response.statusCode == 200 {
                    guard let data = data else { return }
                    DispatchQueue.global(qos: .background).async {
                        do {
                            let decodedPokes = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                            let pokemonsList = decodedPokes.results!
                            
                            observer.onNext(pokemonsList)
                        } catch let error {
                            print("Error decoding: ", error)
                            observer.onError(error)
                        }
                    }
                }
            }
            
            dataTask.resume()
            
            return Disposables.create {}
        }
    }

    func getPokemonDetailByNameFromAPI(url: String) -> Observable<PokemonDetailResponse> {
        return Observable<PokemonDetailResponse>.create { observer in
            guard let url = URL(string: url) else {
                return Disposables.create()
                // fatalError("Missing URL")
            }
            
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
                            observer.onNext(pokemonDetail)
                        } catch let error {
                            print("Error decoding: ", error)
                            observer.onError(error)
                        }
                    }
                }
            }
            
            dataTask.resume()
            
            return Disposables.create {}
        }
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
