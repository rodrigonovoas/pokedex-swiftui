//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 10/10/22.
//

import Foundation

public class DetailViewModel: ObservableObject  {
    @Published var description = ""
    var textUtils: TextUtils = TextUtils()
    
    func getPokemonDescriptionFromAPI(endpoint: String) {
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
                        self.description = self.textUtils.removeSpacesFromText(description: pokemonSpecieDetail.flavor_text_entries[0].flavor_text)
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
