//
//  PokemonDetailScreen.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 27/9/22.
//

import SwiftUI

struct DetailView: View {
    @State var pokemon: PokemonDetailResponse
    @ObservedObject private var viewModel: DetailViewModel = DetailViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: pokemon.sprites.front_default))
                            .frame(width: 75.0, height: 75.0)
                        
                        AsyncImage(url: URL(string: pokemon.sprites.back_default))
                            .frame(width: 75.0, height: 75.0)
                    }
                    
                    Text(pokemon.name).font(.system(size: 26)).bold()
                    
                    HStack {
                        ForEach(0..<pokemon.types.count) { i in
                            Text(pokemon.types[i].type.name)
                        }
                    }
                }
                
                VStack {
                    Divider()
                    
                    Text("General Info").font(.system(size: 22))
                    
                    HStack {
                        Text("Order").font(.system(size: 14))
                        Text(pokemon.order.description).padding(.leading).font(.system(size: 14))
                    }.padding(.top, 1)
                    
                    HStack {
                        Text("Weight").font(.system(size: 14))
                        Text(pokemon.weight.description).font(.system(size: 14))
                    }
                    
                    HStack {
                        Text("Height").font(.system(size: 14))
                        Text(pokemon.height.description).font(.system(size: 14))
                    }
                }
                
                VStack {
                    Divider()
                    
                    Text("Description").font(.system(size: 22))
                    
                    Text(viewModel.description)
                        .font(.system(size: 14))
                        .padding(.top, 1)
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
                }
                
                VStack {
                    Divider()
                    
                    Text("Abilities").font(.system(size: 22))
                    
                    HStack {
                        ForEach(0..<pokemon.abilities.count) { i in
                            Text(pokemon.abilities[i].ability.name)
                                .font(.system(size: 14))
                        }
                    }
                }
                
                VStack {
                    Divider()
                    
                    Text("Stats").font(.system(size: 22))
                    
                    VStack {
                        ForEach(0..<pokemon.stats.count) { i in
                            HStack{
                                Text(pokemon.stats[i].stat.name)
                                    .font(.system(size: 14))
                                Text(pokemon.stats[i].baseStat.description)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                }
                
                VStack {
                    Divider()
                    
                    Text("Moves").font(.system(size: 22))
                    
                    VStack {
                        ForEach(0..<viewModel.moves.count, id: \.self) { i in
                            VStack {
                                HStack{
                                    Text(viewModel.moves[i].name)
                                        .font(.system(size: 14))
                                        .bold()
                                    Text(viewModel.moves[i].type)
                                        .font(.system(size: 14))
                                        .underline()
                                }
                                
                                Text(viewModel.moves[i].description)
                                    .font(.system(size: 14))
                            }.padding().background(.green).cornerRadius(12).padding()
                        }
                    }
                }
            }
        }.onAppear(){
            viewModel.getPokemonDescriptionFromAPI(endpoint: pokemon.species.url)
            downloadPokemonMoves()
        }
    }
    
    private func downloadPokemonMoves(){
        for move in pokemon.moves {
            self.viewModel.getPokemonMoveFromApi(url: move.move.url, name: move.move.name)
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
