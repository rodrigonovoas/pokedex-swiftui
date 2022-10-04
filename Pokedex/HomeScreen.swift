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
    var front_sprite: String
    var back_sprite: String
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
    @State var inputText: String = ""
    @State private var isShowingDetailView = false
    
    var body: some View {
        NavigationView {
        ZStack {
                Image("backgroundTest")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    // TextField("Enter Pokémon name", text: $inputText)
                    //     .padding(.leading, 30)
                    
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
                                    
                                    AsyncImage(url: URL(string: poke.front_sprite))
                                        .frame(width: 32.0, height: 32.0)
                                    
                                    Text("\(poke.order)")
                                        .font(.system(size: 6))
                                        .padding(.top, 10)
                                    
                                    Text("\(poke.name)")
                                        .font(.system(size: 8))
                                    
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
                            getPokemonDetailFromAPI(pokemon: pokemonsList[i].name)
                        }
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func getPokemonDetailFromAPI(pokemon: String){
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
                        let pokemonDetail = try JSONDecoder().decode(PokemonDetailApi.self, from: data)
                        pokemonList.append(PokemonList(name: pokemonDetail.name, order: pokemonDetail.order, front_sprite: pokemonDetail.sprites.front_default, back_sprite: pokemonDetail.sprites.back_default))
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

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 */
