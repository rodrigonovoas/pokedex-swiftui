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
    @Binding var showView: Bool
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .trailing) {
            Text("Back")
                .font(.system(size: 20))
                .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(Color.white)
                .cornerRadius(12)
                .padding(.trailing, 20)
                .onTapGesture {
                    showView = false
                }
            
            HStack {
                TextField("Pokemon name", text: $searchedPokemon, onCommit: {
                    searchPokemon()
                })
                .padding(.init(top: 0, leading: 18, bottom: 0, trailing: 5))
                
                Image("ic_search").resizable().frame(width: 35, height: 35).foregroundColor(.white)
                    .onTapGesture {
                        searchPokemon()
                    }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .withRoundedCornersAndPadding(backgroundColor: Color("endBackgroundGradient"))
            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
    }
    
    private func searchPokemon(){
        if(searchedPokemon.isEmpty){
            resetPokemonList()
        }else{
            viewModel.getPokemonDetailByName(name: searchedPokemon.lowercased())
        }
    }
    
    private func resetPokemonList(){
        boxNumber = 1
        viewModel.getPokemonsFromAPI(from: 0)
    }
}
