//
//  PokemonApiRepositoryProtocol.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 12/10/22.
//

import Foundation
import RxSwift

protocol Repository {
    func getPokemonList(from: Int) -> Observable<[PokemonResponse]>
    func getPokemonDetailByUrl(url: String) -> Observable<PokemonDetailResponse>
    func getPokemonDescription(endpoint: String, completionHandler: @escaping (PokemonSpecieResponse?, Error?) -> Void)
    func getPokemonDetailByName(name: String, completionHandler: @escaping (PokemonDetailResponse?, Error?) -> Void)
}
