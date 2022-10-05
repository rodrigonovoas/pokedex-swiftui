//
//  ContentView.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 25/9/22.
//

import SwiftUI


struct PokemonList: Identifiable {
    var id = UUID()
    var name: String
    var order: Int
    var sprite: String
}

struct PokemonApiList: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonApiResults]?
}

struct PokemonApiResults: Identifiable, Codable {
    var id = UUID()
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

struct PokemonDetailApi: Decodable {
    var name: String
    var order: Int
    var species: PokemonSpecies
    var sprites: PokemonSprites
    
    enum CodingKeys: String, CodingKey {
        case name, order, sprites, species
    }
}

struct HomeScreen: View {
    @State private var pokemonList: [PokemonList] = []
    @State var searchedPokemon: String = ""
    @State private var isShowingDetailView = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
            Image("backgroundTest")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
                VStack {
                    
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
                    
                    if(pokemonList.isEmpty){
                        Spacer()
                        Text("Pokémon no encontrado").background(Color.white)
                        Spacer()
                    }
                    
                    LazyVGrid(columns: [
                        GridItem(.fixed(80)),
                        GridItem(.fixed(80)),
                        GridItem(.fixed(80)),
                        GridItem(.fixed(80))
                    ], spacing: 12, content: {
                        ForEach(pokemonList) { poke in
                            NavigationLink {
                                PokemonDetailScreen(pokemonName: poke.name)
                            } label: {
                                VStack {
                                    Spacer()
                                    
                                    AsyncImage(url: URL(string: poke.sprite), transaction: .init(animation: .spring(response: 1.6))) { phase in
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
                                    .frame(height: 30)
                                    
                                    Text("\(poke.order)")
                                        .font(.system(size: 10))
                                        .padding(.top, 10)
                                    
                                    Text("\(poke.name)")
                                        .font(.system(size: 14))
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    })
                }
            }
        }.onAppear(){
            getPokemonsFromAPI()
        }
    }
        
    
    private func getPokemonsFromAPI(){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=15&offset=0") else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedPokes = try JSONDecoder().decode(PokemonApiList.self, from: data)
                        let pokemonsList = decodedPokes.results!
                        
                        for i in 1...pokemonsList.count - 1 {
                            getPokemonByName(pokemon: pokemonsList[i].name)
                        }
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func getPokemonByName(pokemon: String){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemon)") else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        print("DEBUG-- pokemon downlaoded")
                        let pokemonDetail = try JSONDecoder().decode(PokemonDetailApi.self, from: data)
                        pokemonList.append(PokemonList(name: pokemonDetail.name, order: pokemonDetail.order, sprite: pokemonDetail.sprites.other.officialArtwork.front_default))
                        print(pokemonDetail)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
}
