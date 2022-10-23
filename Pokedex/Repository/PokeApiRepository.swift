//
//  PokeApiRepository.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 12/10/22.
//

import Foundation
import Combine
import RxSwift

struct PokeApiRepository: Repository {
    private let baseURL: String = "https://pokeapi.co/api/v2"
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getPokemonList(from: Int) -> Observable<[PokemonResponse]> {
        return Observable<[PokemonResponse]>.create { observer in
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
                            let decodedPokeList = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                            let pokemonsList = decodedPokeList.results!
                            
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

    func getPokemonDetail(url: String) -> Observable<PokemonDetailResponse> {
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
    
    func getPokemonDescription(endpoint: String, pokemonDescriptionCompletitionHandler: @escaping (PokemonSpecieResponse?, Error?) -> Void) {
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
    
    func getPokemonByName(name: String, pokemonDescriptionCompletitionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void) {
        let urlEndpoint = baseURL + "/pokemon/" + name
        
        guard let url = URL(string: urlEndpoint) else {
            pokemonDescriptionCompletitionHandler(nil, nil)
            return
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
                        pokemonDescriptionCompletitionHandler(pokemonDetail, nil)
                    } catch let error {
                        pokemonDescriptionCompletitionHandler(nil, error)
                    }
                }
            } else{
                pokemonDescriptionCompletitionHandler(nil, nil)
            }
        }
        
        dataTask.resume()
    }
    
    func getPokemonMoveDetail(url: String) -> Observable<PokemonMoveResponse> {
        return Observable<PokemonMoveResponse>.create { observer in
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
                            let pokemonMove = try JSONDecoder().decode(PokemonMoveResponse.self, from: data)
                            observer.onNext(pokemonMove)
                            
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
}
