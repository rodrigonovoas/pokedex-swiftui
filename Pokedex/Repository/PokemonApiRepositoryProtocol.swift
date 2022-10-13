//
//  PokemonApiRepositoryProtocol.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 12/10/22.
//

import Foundation
import RxSwift

protocol PokeApiRepositoryProtocol {
    func getPokemonsFromAPI(from: Int) -> Observable<[Pokemon]>
    func getPokemonDetailByNameFromAPI(url: String) -> Observable<PokemonDetailResponse>
    func getPokemonDescriptionFromAPI(endpoint: String, pokemonDescriptionCompletitionHandler: @escaping (PokemonSpecieResponse?, Error?) -> Void)
}
