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
    @Binding var showView: Bool
    @State private var pokes: [PokemonTeam] = []
    @State private var showDeleteAlert = false
    @State private var selectedPokemonToDelete: String = ""
    
    private let pokemonTeamHelper = PokemonTeamHelper()

    var body: some View {
        VStack(spacing: 0) {
            titleView
                .onTapGesture {
                    self.showView = false
                }
                .zIndex(10)
            
            gridView
                .cornerRadius(12)
                .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 40))
            
            bottomMessagesView
        }
        .onAppear(){
            self.pokes = pokemonTeamHelper.getTeamFromLocalCache()
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
    
    @ViewBuilder
    private var titleView: some View {
        HStack {
            Spacer()
            
            Image("ic_team")
                .foregroundColor(Color.white)
            
            Text("TEAM")
                .withCustomFont(size: 30)
                .foregroundColor(Color.white)
            
            Spacer()
            
            Image("ic_cancel")
                .renderingMode(.template)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.white)
                .padding(.trailing, 5)
            
        }
        .padding(5)
        .withRoundedCornersAndFullWidthStyle(backgroundColor: Color("customTeamHeader"))
        .padding(.init(top: 0, leading: 40, bottom: 5, trailing: 40))
    }
    
    @ViewBuilder
    private var gridView: some View {
            ForEach(pokes) { poke in
                HStack {
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
                    .frame(width: 80, height: 60)
                    
                    Text(poke.name.capitalized).withCustomFont(size: 24)
                }
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(12)
                .padding(.bottom, 5)
                .onLongPressGesture {
                    selectedPokemonToDelete = poke.name
                    showDeleteAlert = true
                }
            }
    }
    
    @ViewBuilder
    private var bottomMessagesView: some View {
        HStack {
            Spacer()
            
            Text("- Long press:  delete pokemon")
                .withCustomFont(size: 20)
                .padding(5)
                .background(Color.white)
                .cornerRadius(12)
        }
        .padding(.top, 10)
        .padding(.trailing, 40)
    }
}

