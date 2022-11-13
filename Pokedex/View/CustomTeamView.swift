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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 0) {
            titleView
                .onTapGesture {
                    self.showView = false
                }
                .zIndex(10)
            
            gridView
            
            bottomMessagesView
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
            
            Text("TEAM")
                .withCustomFont(size: 26)
            
            Spacer()
            
            Image("ic_cancel")
                .resizable()
                .frame(width: 15, height: 15)
                .padding(.trailing, 5)
        }
        .padding(5)
        .withRoundedCornersAndFullWidthStyle(backgroundColor: .white)
        .padding(.init(top: 0, leading: 40, bottom: 5, trailing: 40))
    }
    
    @ViewBuilder
    private var gridView: some View {
        LazyVGrid(columns: columns) {
            ForEach(pokes) { poke in
                VStack{
                    Text(poke.name).withCustomFont(size: 20)
                    
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
                    .frame(width: 100, height: 80)
                }
                .padding(5)
                .background(.white)
                .overlay(
                       RoundedRectangle(cornerRadius: 12)
                           .stroke(LinearGradient(gradient: Gradient(colors: [Color("startTeamBackgroundColor"), Color("endTeamBackgroundColor")]), startPoint: .top, endPoint: .bottom), lineWidth: 8)
                   )
                .cornerRadius(12)
                .onLongPressGesture {
                    selectedPokemonToDelete = poke.name
                    showDeleteAlert = true
                }
            }
        }
        .frame(minHeight: 300)
        .padding(20)
        .background(
                Image("teamBackgroundImage")
                    .resizable()
                    .scaledToFill()
            )
        .cornerRadius(12)
        .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 40))
        .onAppear(){
            self.pokes = pokemonTeamHelper.getTeamFromLocalCache()
        }
    }
    
    @ViewBuilder
    private var bottomMessagesView: some View {
        Text("- Long press: delete pokemon")
            .withCustomFont(size: 20)
            .padding(5)
            .background(Color.white)
            .padding(.top, 10)
    }
}

