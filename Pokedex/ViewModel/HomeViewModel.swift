//
//  HomeViewModel.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 10/10/22.
//

import Foundation

public class HomeViewModel: ObservableObject {
    @Published var pokemonList: [PokemonDetailResponse] = []
    
    func getPokemonsFromAPI(){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=13&offset=0") else { fatalError("Missing URL") }
        
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
                            self.getPokemonDetailByNameFromAPI(pokemon: pokemonsList[i].name)
                        }
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func getPokemonDetailByNameFromAPI(pokemon: String){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemon)") else { fatalError("Missing URL") }
        
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
                        print("DEBUG-- pokemon downlaoded")
                        let pokemonDetail = try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
                        self.pokemonList.append(pokemonDetail)
                        print(pokemonDetail)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
}
