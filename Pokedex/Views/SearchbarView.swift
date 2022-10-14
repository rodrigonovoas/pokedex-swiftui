//
//  SearchbarView.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 14/10/22.
//

import Foundation
import SwiftUI

struct SearchbarView: View {
    @Binding var searchedPokemon: String
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter pokemon name")
                .font(.custom("Pokemon-Pixel-Font", size: 24))
                .padding(.leading, 18)
            
            TextField("", text: $searchedPokemon, onCommit: {
                if(searchedPokemon.isEmpty){
                    viewModel.getPokemonsFromAPI(from: 0)
                }else{
                    viewModel.getPokemonByName(name: searchedPokemon.lowercased())
                }
            })
            .padding(.trailing, 18)
            .padding(.leading, 18)
            
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .background(Color("endBackgroundGradient"))
        .padding(.trailing, 9)
        .padding(.leading, 9)
        .cornerRadius(15)
    }
}
