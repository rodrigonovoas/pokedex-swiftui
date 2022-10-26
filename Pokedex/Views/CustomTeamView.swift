//
//  CustomTeamView.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 24/10/22.
//

import Foundation
import SwiftUI

public struct PokemonTeam: Identifiable, Codable {
    public var id = UUID()
    var name: String
    var imageUrl: String
}

struct CustomTeamView: View {
    @State private var pokes: [PokemonTeam] = []
    @State private var showDeleteAlert = false
    @State private var selectedPokemonToDelete: String = ""
    
    private let pokemonTeamHelper = PokemonTeamHelper()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            Text("Pokemon Team").font(.system(size: 30))
            LazyVGrid(columns: columns) {
                ForEach(pokes) { poke in
                    VStack{
                        Text(poke.name)
                        
                        AsyncImage(url: URL(string: poke.imageUrl), transaction: .init(animation: .spring(response: 1.6))) { phase in
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
                    .padding(5)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .onLongPressGesture {
                        selectedPokemonToDelete = poke.name
                        showDeleteAlert = true
                    }
                }
            }
            .padding(20)
            .background(Color.red)
            .cornerRadius(12)
            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
            .onAppear(){
                self.pokes = pokemonTeamHelper.getTeamFromLocalCache()
            }
        }
        .alert(isPresented:$showDeleteAlert) {
                  Alert(
                      title: Text("Are you sure you want to remove this pokemon from your team?"),
                      primaryButton: .destructive(Text("Delete")) {
                          self.pokes = self.pokemonTeamHelper.deletePokemon(pokemonName: self.selectedPokemonToDelete, currentTeam: self.pokes)
                      },
                      secondaryButton: .cancel()
                  )
              }
    }
}

