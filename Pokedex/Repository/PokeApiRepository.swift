//
//  PokeApiRepository.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 12/10/22.
//

import Foundation
import RxSwift

struct PokeApiRepository: Repository {
    private let pokemonListLimit = 15
    private let baseURL: String = "https://pokeapi.co/api/v2"
    private let listEndpoint = "/pokemon"
    private let detailEndpoint = "/pokemon/"
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getPokemonList(from: Int) -> Observable<[PokemonResponse]> {
        return Observable<[PokemonResponse]>.create { observer in
            let getPokemonsBaseUrl = baseURL + listEndpoint
            let urlEndpoint = getPokemonsBaseUrl + "?limit=" + pokemonListLimit.description + "&offset="+from.description
            
            guard let url = URL(string: urlEndpoint) else {
                return Disposables.create()
            }
            
            let urlRequest = URLRequest(url: url)
            let dataTask = self.session.dataTask(with: urlRequest) { (data, response, error) in
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
            return Disposables.create()
        }
    }

    func getPokemonDetailByUrl(url: String) -> Observable<PokemonDetailResponse> {
        return Observable<PokemonDetailResponse>.create { observer in
            guard let url = URL(string: url) else {
                return Disposables.create()
            }
            
            let urlRequest = URLRequest(url: url)
            let dataTask = self.session.dataTask(with: urlRequest) { (data, response, error) in
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
            
            return Disposables.create()
        }
    }
    
    func getPokemonDetailByName(name: String, completionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void) {
        let urlEndpoint = baseURL + detailEndpoint + name
        
        guard let url = URL(string: urlEndpoint) else {
            completionHandler(nil, nil)
            return
        }

        let urlRequest = URLRequest(url: url)
        let dataTask = self.session.dataTask(with: urlRequest) { (data, response, error) in
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
                        completionHandler(pokemonDetail, nil)
                    } catch let error {
                        completionHandler(nil, error)
                    }
                }
            } else{
                completionHandler(nil, nil)
            }
        }
        
        dataTask.resume()
    }
    
    
    func getPokemonDescription(endpoint: String, completionHandler: @escaping (PokemonSpecieResponse?, Error?) -> Void) {
        guard let url = URL(string: endpoint) else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)
        let dataTask = self.session.dataTask(with: urlRequest) { (data, response, error) in
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
                        completionHandler(pokemonSpecieDetail, nil)
                    } catch let error {
                        completionHandler(nil, error)
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }

    func getPokemonMoveDetailByUrl(url: String) -> Observable<PokemonMoveResponse> {
        return Observable<PokemonMoveResponse>.create { observer in
            guard let url = URL(string: url) else {
                return Disposables.create()
            }
            
            let urlRequest = URLRequest(url: url)
            let dataTask = self.session.dataTask(with: urlRequest) { (data, response, error) in
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
            return Disposables.create()
        }
    }
}
