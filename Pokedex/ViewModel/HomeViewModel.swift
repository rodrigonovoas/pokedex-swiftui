//
//  HomeViewModel.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 10/10/22.
//

import Foundation

public class HomeViewModel: ObservableObject {
    @Published var pokemonList: [PokemonDetailResponse] = []
    private var repository: PokeApiRepositoryProtocol
    
    init() {
        repository = PokeApiRepository(session: URLSession.shared)
    }
    
    func getPokemonsFromAPI(){
        repository.getPokemonsFromAPI(pokemonCompletitionHandler: { pokemon, error in
            if let pokemon = pokemon {
                self.pokemonList.append(pokemon)
            }
        })
    }
    
}
