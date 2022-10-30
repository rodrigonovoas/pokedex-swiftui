//
//  SearchbarView.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 14/10/22.
//

import Foundation
import SwiftUI

struct SearchbarView: View {
    @Binding var boxNumber: Int
    @Binding var searchedPokemon: String
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            Text("Enter pokemon name")
                .font(.custom("Pokemon-Pixel-Font", size: 24))
                .padding(.leading, 18)
            
            TextField("", text: $searchedPokemon, onCommit: {
                if(searchedPokemon.isEmpty){
                    boxNumber = 1
                    viewModel.getPokemonsFromAPI(from: 0)
                }else{
                    viewModel.getPokemonByName(name: searchedPokemon.lowercased())
                }
            })
            .padding(.init(top: 0, leading: 18, bottom: 0, trailing: 18))
            
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .background(Color("endBackgroundGradient"))
        .cornerRadius(12)
        .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}
