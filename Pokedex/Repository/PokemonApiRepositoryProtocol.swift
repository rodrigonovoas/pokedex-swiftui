//
//  PokemonApiRepositoryProtocol.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 12/10/22.
//

import Foundation

protocol PokeApiRepositoryProtocol {
    func getPokemonsFromAPI(pokemonCompletitionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void)
    func getPokemonDetailByNameFromAPI(pokemon: String, pokemonDetailCompletitionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void)
    func getPokemonDescriptionFromAPI(endpoint: String, pokemonDescriptionCompletitionHandler: @escaping (PokemonSpecieResponse?, Error?) -> Void)
}
