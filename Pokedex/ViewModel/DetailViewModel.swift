//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 10/10/22.
//

import Foundation
import RxSwift

public struct Move: Identifiable {
    public var id = UUID()
    var name: String
    var type: String
    var accuracy: Int
    var power: Int
    var description: String
}

public class DetailViewModel: ObservableObject  {
    @Published var description = ""
    @Published var moves:[Move] = []
    
    private var repository: PokeApiRepository
    private var textUtils: TextUtils = TextUtils()
    
    private var pokemonMoves: Observable<PokemonMoveResponse>?
    private let disposeBag = DisposeBag()
    
    
    init(){
        repository = PokeApiRepository(session: URLSession.shared)
    }
    
    func getPokemonDescriptionFromAPI(endpoint: String) {
        repository.getPokemonDescription(endpoint: endpoint, pokemonDescriptionCompletitionHandler: { pokemonSpecieResponse, error in
            if let pokemonSpecieResponse = pokemonSpecieResponse {
                self.description = self.textUtils.removeBlankSpacesFromText(description: pokemonSpecieResponse.flavor_text_entries[0].flavor_text)
            }
        })
    }
    
    func getPokemonMoveFromApi(url: String, name: String) {
        pokemonMoves = repository.getPokemonMoveDetailByUrl(url: url)

        pokemonMoves?.subscribe(onNext: { [weak self] (move) in
            var moveDescription = ""
            if(!move.effectEntries.isEmpty) {
                moveDescription = move.effectEntries[0].shortEffect
            }
            self?.moves.append(Move(name: name, type: move.type.name, accuracy: move.accuracy ?? 0, power: move.power ?? 0, description: moveDescription))
        })
        .disposed(by: disposeBag)
    }
}
