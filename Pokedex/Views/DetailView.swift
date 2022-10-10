//
//  PokemonDetailScreen.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 27/9/22.
//

import SwiftUI

struct DetailView: View {
    @State var pokemon: PokemonDetailResponse
    @State var description = ""
    @ObservedObject private var viewModel: DetailViewModel = DetailViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: pokemon.sprites.front_default))
                        .frame(width: 100.0, height: 100.0)
                    
                    AsyncImage(url: URL(string: pokemon.sprites.back_default))
                        .frame(width: 100.0, height: 100.0)
                }
                
                Text(pokemon.name).font(.system(size: 22)).bold()
                
                Text(viewModel.description)
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                    .padding(.leading, 20)
            }
        }.onAppear(){
            viewModel.getPokemonDescriptionFromAPI(endpoint: pokemon.species.url)
        }
    }
}

/*
struct PokemonDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailScreen(pokemonId: "1")
    }
}
 */
