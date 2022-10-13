//
//  HomeViewModel.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 10/10/22.
//

import Foundation
import RxSwift

public class HomeViewModel: ObservableObject {
    @Published var pokemonHomeList: [PokemonDetailResponse] = []
    private var from: Int = 0
    private var disableRequest = false
    private var repository: PokeApiRepositoryProtocol
    
    private var pokemons: Observable<[Pokemon]>?
    private var pokeDetail: Observable<PokemonDetailResponse>?
    private let disposeBag = DisposeBag()
    
    init() {
        repository = PokeApiRepository(session: URLSession.shared)
    }
    
    func getFromNumber() -> Int {
        return from
    }
    
    func getPokemonsFromAPI(from: Int){
        self.pokemonHomeList.removeAll()
        self.from = from
        
        pokemons = repository.getPokemonsFromAPI(from: from)
        
        pokemons?.subscribe(onNext: { [weak self] (list) in
            for i in 0...(list.count-1) {
                if(i == -1) { return }
                self?.getAndAppendPokemonDetailToList(list: list, i: i)
            }
        })
        .disposed(by: disposeBag)
    }
    
    fileprivate func getAndAppendPokemonDetailToList(list: [Pokemon], i: Int) {
        var pokeDetail: Observable<PokemonDetailResponse>?
        pokeDetail = repository.getPokemonDetailByNameFromAPI(url: list[i].url)
        
        pokeDetail?.subscribe(onNext: { [weak self] (detail) in
            self?.pokemonHomeList.append(detail)
            self?.repository.getPokemonDetailByNameFromAPI(url: list[i].url)
            
            if(self?.pokemonHomeList.count == list.count){
                self?.pokemonHomeList.sort(by: { $0.order < $1.order })
            }
        })
        .disposed(by: self.disposeBag)
    }
}
