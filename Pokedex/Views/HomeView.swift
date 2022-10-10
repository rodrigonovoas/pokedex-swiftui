//
//  ContentView.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 25/9/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel
    @State var searchedPokemon: String
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                if(viewModel.pokemonList.isEmpty){
                    Spacer()
                    Text("Pokémon not found").background(Color.white)
                    Spacer()
                }
                
                VStack {
                    
                    HStack {
                        Image("ic_left_arrow").resizable().frame(width: 30, height: 30)
                            .padding(.leading, 10)
                        
                        Text("BOX 1")
                            .frame(maxWidth: .infinity, maxHeight: 30)
                            .background(Rectangle().fill(Color.white).cornerRadius(4))
                            .padding(.trailing, 10)
                            .padding(.leading, 10)
                        
                        Image("ic_right_arrow").resizable().frame(width: 30, height: 30)
                            .padding(.trailing, 10)
                    }

                    /*
                    HStack {
                        Image(systemName: "magnifyingglass").padding(.leading, 20)
                        TextField("Search...", text: $searchedPokemon, onCommit: {
                            pokemonList.removeAll()
                            if(searchedPokemon.isEmpty){
                                getPokemonsFromAPI()
                            }else{
                                getPokemonByName(pokemon: searchedPokemon.lowercased())
                            }
                        }).padding(.trailing, 20)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
                     */
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.fixed(100)),
                            GridItem(.fixed(100)),
                            GridItem(.fixed(100))
                        ], spacing: 4, content: {
                            ForEach(viewModel.pokemonList) { poke in
                                NavigationLink {
                                    DetailView(pokemon: poke)
                                } label: {
                                    VStack {
                                        AsyncImage(url: URL(string: poke.sprites.other.officialArtwork.front_default), transaction: .init(animation: .spring(response: 1.6))) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .progressViewStyle(.circular)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            case .failure:
                                                Text("Failed fetching image. Make sure to check your data connection and try again.")
                                                    .foregroundColor(.red)
                                            @unknown default:
                                                Text("Unknown error. Please try again.")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .frame(height: 80)
                                        /*
                                        .overlay(
                                            Image("ic_cursor")
                                                .resizable()
                                                  .frame(width: 20.0, height: 20.0)
                                            ,alignment: .bottomTrailing)
                                         */
                                    }
                                    .padding()
                                    .overlay(
                                        Text("\(poke.order) \(poke.name)")
                                            .font(.system(size: 14))
                                        ,alignment: .bottom)
                                }
                            }
                        })
                    }
                    
                    HStack {
                        Image("ic_search").resizable().frame(width: 50, height: 50).padding(.leading, 20).foregroundColor(.white)
                        Image("ic_team").resizable().frame(width: 50, height: 50).padding(.leading, 10).foregroundColor(.white)
                        Spacer()
                        // Image("ic_ok").resizable().frame(width: 50, height: 50).padding(.trailing, 20).foregroundColor(.white)
                    }
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .background(LinearGradient(gradient: Gradient(colors: [Color("startBackgroundGradient"), Color("endBackgroundGradient")]), startPoint: .top, endPoint: .bottom))
        }.onAppear(){
            viewModel.getPokemonsFromAPI()
        }
    }
    
    init() {
        searchedPokemon = ""
        viewModel = HomeViewModel()
    }
}
