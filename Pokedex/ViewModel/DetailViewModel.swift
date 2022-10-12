//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 10/10/22.
//

import Foundation

public class DetailViewModel: ObservableObject  {
    @Published var description = ""
    private var repository: PokeApiRepositoryProtocol
    private var textUtils: TextUtils = TextUtils()
    
    init(){
        repository = PokeApiRepository(session: URLSession.shared)
    }
    
    func getPokemonDescriptionFromAPI(endpoint: String) {
        repository.getPokemonDescriptionFromAPI(endpoint: endpoint, pokemonDescriptionCompletitionHandler: { pokemonSpecieResponse, error in
            if let pokemonSpecieResponse = pokemonSpecieResponse {
                self.description = self.textUtils.removeSpacesFromText(description: pokemonSpecieResponse.flavor_text_entries[0].flavor_text)
            }
        })
    }
}
