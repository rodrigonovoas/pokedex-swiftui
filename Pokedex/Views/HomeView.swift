//
//  ContentView.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 25/9/22.
//

import SwiftUI
import FLAnimatedImage

struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel
    @State private var searchedPokemon: String
    @State private var boxNumber: Int = 1
    @State private var showTeam: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                if(viewModel.showNotFoundMessage){
                    pokemonNotFoundView
                }
                
                VStack {
                    headerBoxView
                    
                    tableView
                    
                    bottomView
                }
                
                if(showTeam){
                    CustomTeamView(showView: $showTeam)
                }
            }
            .navigationBarTitle(Text("Home").font(.subheadline), displayMode: .inline)
            .withGradientBackgroundStyle(startColor: "startBackgroundGradient", endColor: "endBackgroundGradient")
        }.onAppear(){
            viewModel.getPokemonsFromAPI(from: 0)
        }.overlay(){
            VStack {
                if(viewModel.pokemonHomeList.isEmpty && !viewModel.showNotFoundMessage){
                    GIFView(type: .url(URL(string: "https://media.tenor.com/fSsxftCb8w0AAAAi/pikachu-running.gif")!))
                        .frame(width: 75, height: 50)
                        .padding()
                    
                    Text("LOADING...").withCustomFont(size: 20).onAppear(){ viewModel.activateSearchbar = false }
                }
                
                if(viewModel.activateSearchbar){
                    SearchbarView(boxNumber: $boxNumber, searchedPokemon: $searchedPokemon, viewModel: viewModel)
                }
            }
        }
    }
    
    @ViewBuilder
    private var pokemonNotFoundView: some View {
        Spacer()
        VStack {
            Image("ic_pikachu_sorprendido").resizable().frame(width: 125, height: 100)
            Text("Pokémon not found").background(Color.white)
        }
        Spacer()
    }
    
    @ViewBuilder
    private var headerBoxView: some View {
        HStack {
            Image("ic_left_arrow")
                .topIconSizeStyle()
                .padding(.leading, 10)
                .onTapGesture {
                    if(viewModel.getFromNumber() >= 12){
                        viewModel.getPokemonsFromAPI(from: viewModel.getFromNumber() - 12)
                        boxNumber -= 1
                    }
                }
            
            Text("BOX " + boxNumber.description)
                .withCustomFont(size: 24)
                .frame(maxWidth: .infinity, maxHeight: 30)
                .background(Rectangle().fill(Color.white).cornerRadius(4))
                .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            Image("ic_right_arrow")
                .topIconSizeStyle()
                .padding(.trailing, 10)
                .onTapGesture {
                    viewModel.getPokemonsFromAPI(from: viewModel.getFromNumber() + 12)
                    boxNumber += 1
                }
        }
    }
    
    @ViewBuilder
    private var tableView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.fixed(100)),
                GridItem(.fixed(100)),
                GridItem(.fixed(100))
            ], spacing: 4, content: {
                ForEach(viewModel.pokemonHomeList) { poke in
                    NavigationLink {
                        DetailView(pokemon: poke)
                            .onAppear(){
                                viewModel.activateSearchbar = false
                            }
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
                        }
                        .padding()
                        .overlay(
                            Text("\(poke.order)  \(poke.name)")
                                .withCustomFont(size: 16)
                            ,alignment: .bottom)
                    }
                }
            })
        }
    }
    
    @ViewBuilder
    private var bottomView: some View {
        HStack {
            Image("ic_search").bottomIconSizeStyle().padding(.leading, 20).foregroundColor(.white)
                .onTapGesture {
                    viewModel.activateSearchbar = !viewModel.activateSearchbar
                }
            
            Image("ic_team").bottomIconSizeStyle().padding(.leading, 10).foregroundColor(.white)
                .onTapGesture {
                    showTeam = !showTeam
                }
            
            Spacer()
 
            if(!searchedPokemon.isEmpty){
                Text("Clear filter")
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
                    .onTapGesture {
                        searchedPokemon = ""
                        boxNumber = 1
                        viewModel.getPokemonsFromAPI(from: 0)
                    }
            }
        }.padding(.bottom, 20)
    }
    
    init() {
        searchedPokemon = ""
        viewModel = HomeViewModel()
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Pokemon-Pixel-Font", size: 30)!]
    }
}

private extension Image {
    func topIconSizeStyle() -> some View  {
        self.resizable()
            .frame(width: 30, height: 30)
    }
    
    func bottomIconSizeStyle() -> some View  {
        self.resizable()
            .frame(width: 50, height: 50)
    }
}
