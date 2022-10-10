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
                
                Text(description)
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                    .padding(.leading, 20)
            }
        }.onAppear(){
            getPokemonDescriptionFromAPI(endpoint: pokemon.species.url)
        }
    }
    
    private func removeSpacesFromText(description: String) -> String {
        let descriptionFormatted = description.replacingOccurrences(of: "\n", with: " ")
        return descriptionFormatted.replacingOccurrences(of: "\u{0C}", with: " ")
    }
    
    private func getPokemonDescriptionFromAPI(endpoint: String){
        guard let url = URL(string: endpoint) else { fatalError("Missing URL") }
        
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
                        let pokemonSpecieDetail = try JSONDecoder().decode(PokemonSpecieResponse.self, from: data)
                        self.description = removeSpacesFromText(description: pokemonSpecieDetail.flavor_text_entries[0].flavor_text)
                        print(pokemonSpecieDetail)
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
struct PokemonDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailScreen(pokemonId: "1")
    }
}
 */
