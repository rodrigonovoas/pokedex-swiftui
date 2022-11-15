//
//  PokemonDetailScreen.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 27/9/22.
//

import SwiftUI

struct DetailView: View {
    @State private var uiMessage: String = ""
    @State private var showCommonDialog: Bool = false
    @State var pokemon: PokemonDetailResponse
    @StateObject private var viewModel: DetailViewModel = DetailViewModel()
    
    private let pokemonTeamHelper = PokemonTeamHelper()
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                headerView
                
                generalInfoView
                
                descriptionView
                
                abilitiesView
                
                movesView
                
                addPokemonToTeamView
            }
            
            if(showCommonDialog) {
                CommonDialogView(message: $uiMessage, showCommonDialog: $showCommonDialog)
            }
        }.onAppear(){
            viewModel.getPokemonDescriptionFromAPI(endpoint: pokemon.species.url)
            downloadPokemonMoves()
        }.onChange(of: uiMessage) { message in
            if(!message.isEmpty){
                showCommonDialog = true
            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack {
            HStack {
                Image("ic_pokeball").resizable().frame(width: 25, height: 25)
                Text("N. " + pokemon.pokemonId.description).padding(.leading).font(.system(size: 16))
                Text(pokemon.name.capitalized).font(.system(size: 16)).bold()
            }
            .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
            .withRoundedCornersAndFullWidthStyle(backgroundColor: Color("startSearchbarGradient"))
            .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            VStack {
                HStack {
                    AsyncImage(url: URL(string: pokemon.sprites.front_default))
                        .frame(minWidth: 35, maxWidth: 75, minHeight: 35, maxHeight: 75)
                    
                    AsyncImage(url: URL(string: pokemon.sprites.back_default))
                        .frame(minWidth: 35, maxWidth: 75, minHeight: 35, maxHeight: 75)
                }
                
                HStack {
                    ForEach(0..<pokemon.types.count) { i in
                        Text(pokemon.types[i].type.name)
                            .withNormalTextStyle()
                            .foregroundColor(Color.white)
                            .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background(Color(getPokemonTypeBackgroundColor(type: pokemon.types[i].type.name)))
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("startSearchbarGradient"), lineWidth: 8)
            )
            .cornerRadius(12)
            .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
        }
    }
    
    private func getPokemonTypeBackgroundColor(type: String) -> String {
        return type + "TypeColor"
    }
   
    @ViewBuilder
    private var generalInfoView: some View {
        VStack(spacing: 0) {
            Text("General Info").font(.system(size: 14))
                .titleBackgroundStyle(cornerOne: .topLeft, cornerTwo: .topRight)
                .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            VStack {
                HStack {
                    Text("Weight").withNormalTextStyle()
                    Text((Double(pokemon.height)/10).description + " m").withNormalTextStyle()
                }
                
                HStack {
                    Text("Height").withNormalTextStyle()
                    Text((Double(pokemon.height)/10).description + " m").withNormalTextStyle()
                }
            }
            .padding()
            .contentBackgroundStyle(cornerOne: .bottomLeft, cornerTwo: .bottomRight)
            .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
        }
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        VStack(spacing: 0) {
            Text("Description").font(.system(size: 14))
                .titleBackgroundStyle(cornerOne: .topLeft, cornerTwo: .topRight)
                .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            VStack {
                Text(viewModel.description)
                    .withNormalTextStyle()
                    .padding(.init(top: 1, leading: 20, bottom: 0, trailing: 20))
            }
            .padding()
            .contentBackgroundStyle(cornerOne: .bottomLeft, cornerTwo: .bottomRight)
            .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
        }
    }
    
    @ViewBuilder
    private var abilitiesView: some View {
        VStack(spacing: 0) {
            Text("Abilities").font(.system(size: 14))
                .titleBackgroundStyle(cornerOne: .topLeft, cornerTwo: .topRight)
                .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            VStack {
                HStack {
                    ForEach(0..<pokemon.abilities.count) { i in
                        Text(pokemon.abilities[i].ability.name.capitalized)
                            .withNormalTextAndUnderlinedStyle()
                    }
                }
            }
            .padding()
            .contentBackgroundStyle(cornerOne: .bottomLeft, cornerTwo: .bottomRight)
            .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
        }
    }
    
    @ViewBuilder
    private var movesView: some View {
        VStack(spacing: 0) {
            Text("Moves").font(.system(size: 14))
                .titleBackgroundStyle(cornerOne: .topLeft, cornerTwo: .topRight)
                .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            VStack {
                NavigationLink {
                    MovesView(moves: self.viewModel.moves)
                } label: {
                    HStack {
                        Image("ic_moves").resizable().frame(width: 35, height: 35)
                        Text("List").font(.system(size: 22))
                    }
                }
            }
            .padding()
            .contentBackgroundStyle(cornerOne: .bottomLeft, cornerTwo: .bottomRight)
            .padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
        }
    }
    
    @ViewBuilder
    private var addPokemonToTeamView: some View {
        HStack {
            Text("Add to your team")
            Image("ic_team")
        }
        .padding()
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("startSearchbarGradient"), lineWidth: 8)
        )
        .cornerRadius(12)
        .onTapGesture {
            let teamIsNotFull = self.pokemonTeamHelper.addPokemonToTeamList(pokemonName: self.pokemon.name, pokemonImage: self.pokemon.sprites.front_default)
            
            showUiMessageAfterAddingPokemon(addingStatus: teamIsNotFull)
        }
    }
    
    private func downloadPokemonMoves(){
        for move in pokemon.moves {
            self.viewModel.getPokemonMoveFromApi(url: move.move.url, name: move.move.name)
        }
    }
    
    private func showUiMessageAfterAddingPokemon(addingStatus: PokemonTeamAdditionStatus){
        switch addingStatus {
        case PokemonTeamAdditionStatus.alreadyAdded:
            self.uiMessage = "This pokemon is already on your team!"
        case PokemonTeamAdditionStatus.teamIsFull:
            self.uiMessage = "You can't add more pokemons to your team! You must remove one of them."
        case PokemonTeamAdditionStatus.success:
            self.uiMessage = "Pokemon added to your team!"
        case PokemonTeamAdditionStatus.failed:
            self.uiMessage = "An error ocurred while adding this pokemon to your team."
        default:
            self.uiMessage = "An error ocurred while adding this pokemon to your team."
        }
    }
}

/// STYLES

private extension View {
    func contentBackgroundStyle(cornerOne: UIRectCorner, cornerTwo: UIRectCorner) -> some View {
        self.frame(maxWidth: .infinity)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("startSearchbarGradient"), lineWidth: 10)
            )
            .cornerRadius(12, corners: [cornerOne, cornerTwo])
    }

    func titleBackgroundStyle(cornerOne: UIRectCorner, cornerTwo: UIRectCorner) -> some View {
        self.padding(.top, 5)
            .frame(maxWidth: .infinity)
            .background(Color("startSearchbarGradient"))
            .cornerRadius(12, corners: [cornerOne, cornerTwo])
    }
}

