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
    @Published  var activateSearchbar: Bool = false
    @Published  var showNotFoundMessage: Bool = false
    
    private var from: Int = 0
    private var disableRequest = false
    private var repository: PokeApiRepository
    
    private var pokemons: Observable<[PokemonResponse]>?
    private var pokeDetail: Observable<PokemonDetailResponse>?
    private let disposeBag = DisposeBag()
    
    init() {
        repository = PokeApiRepository(session: URLSession.shared)
    }
    
    func getFromNumber() -> Int {
        return from
    }
    
    func getPokemonsFromAPI(from: Int){
        self.showNotFoundMessage = false
        self.pokemonHomeList.removeAll()
        self.from = from
        
        pokemons = repository.getPokemonList(from: from)
        
        pokemons?.subscribe(onNext: { [weak self] (list) in
            for i in 0...(list.count-1) {
                if(i == -1) { return }
                self?.addPokemonDetailToList(list: list, i: i)
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func addPokemonDetailToList(list: [PokemonResponse], i: Int) {
        var pokeDetail: Observable<PokemonDetailResponse>?
        pokeDetail = repository.getPokemonDetailByUrl(url: list[i].url)
        
        pokeDetail?.subscribe(onNext: { [weak self] (detail) in
            self?.pokemonHomeList.append(detail)
            self?.repository.getPokemonDetailByUrl(url: list[i].url)
            
            if(self?.pokemonHomeList.count == list.count){
                self?.pokemonHomeList.sort(by: { $0.order < $1.order })
            }
        })
        .disposed(by: self.disposeBag)
    }
    
    func getPokemonByName(name: String) {
        repository.getPokemonDetailByName(name: name, pokemonDescriptionCompletitionHandler: { pokemonDetail, error in
            self.pokemonHomeList.removeAll()
            
            if(pokemonDetail == nil) {
                DispatchQueue.main.async{
                    self.showNotFoundMessage = true
                    self.activateSearchbar = false
                }
                return
            }
            
            if let pokemonDetail = pokemonDetail {
                self.showNotFoundMessage = false
                self.pokemonHomeList.append(pokemonDetail)
            }
            
            self.activateSearchbar = false
        })
    }

}
