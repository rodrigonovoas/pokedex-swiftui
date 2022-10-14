//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 10/10/22.
//

import Foundation

public class DetailViewModel: ObservableObject  {
    @Published var description = ""
    private var repository: PokeApiRepository
    private var textUtils: TextUtils = TextUtils()
    
    init(){
        repository = PokeApiRepository(session: URLSession.shared)
    }
    
    func getPokemonDescriptionFromAPI(endpoint: String) {
        repository.getPokemonDescription(endpoint: endpoint, pokemonDescriptionCompletitionHandler: { pokemonSpecieResponse, error in
            if let pokemonSpecieResponse = pokemonSpecieResponse {
                self.description = self.textUtils.removeSpacesFromText(description: pokemonSpecieResponse.flavor_text_entries[0].flavor_text)
            }
        })
    }
}
