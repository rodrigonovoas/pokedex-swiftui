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
    @ObservedObject private var viewModel: DetailViewModel = DetailViewModel()
    
    private let pokemonTeamHelper = PokemonTeamHelper()
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                headerView
                
                generalInfoView
                
                descriptionView
                
                abilitiesView
                
                movesView
                
                Button("Add Pokemon") {
                    let teamIsNotFull = self.pokemonTeamHelper.addPokemonToTeamList(pokemonName: self.pokemon.name, pokemonImage: self.pokemon.sprites.other.officialArtwork.front_default)
                    
                    showUiMessageAfterAddingPokemon(addingStatus: teamIsNotFull)
                }
            }
            
            if(showCommonDialog) {
                CommonDialogView(message: $uiMessage, showCommonDialog: $showCommonDialog)
            }
        }.onAppear(){
            viewModel.getPokemonDescriptionFromAPI(endpoint: pokemon.species.url)
            downloadPokemonMoves()
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: pokemon.sprites.front_default))
                    .frame(width: 75.0, height: 75.0)
                
                AsyncImage(url: URL(string: pokemon.sprites.back_default))
                    .frame(width: 75.0, height: 75.0)
            }
            
            Text(pokemon.name).font(.system(size: 26)).bold()
            
            HStack {
                ForEach(0..<pokemon.types.count) { i in
                    Text(pokemon.types[i].type.name)
                }
            }
        }
    }
   
    @ViewBuilder
    private var generalInfoView: some View {
        VStack {
            Divider()
            
            Text("General Info").font(.system(size: 22))
            
            HStack {
                Text("Order").font(.system(size: 14))
                Text(pokemon.order.description).padding(.leading).font(.system(size: 14))
            }.padding(.top, 1)
            
            HStack {
                Text("Weight").font(.system(size: 14))
                Text(pokemon.weight.description).font(.system(size: 14))
            }
            
            HStack {
                Text("Height").font(.system(size: 14))
                Text(pokemon.height.description).font(.system(size: 14))
            }
        }
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        VStack {
            Divider()
            
            Text("Description").font(.system(size: 22))
            
            Text(viewModel.description)
                .font(.system(size: 14))
                .padding(.top, 1)
                .padding(.trailing, 20)
                .padding(.leading, 20)
        }
    }
    
    @ViewBuilder
    private var abilitiesView: some View {
        VStack {
            Divider()
            
            Text("Abilities").font(.system(size: 22))
            
            HStack {
                ForEach(0..<pokemon.abilities.count) { i in
                    Text(pokemon.abilities[i].ability.name)
                        .font(.system(size: 14))
                }
            }
        }
    }
    
    @ViewBuilder
    private var movesView: some View {
        VStack {
            Divider()
            
            Text("Moves").font(.system(size: 22))
            
            VStack {
                ForEach(0..<viewModel.moves.count, id: \.self) { i in
                    VStack {
                        HStack{
                            Text(viewModel.moves[i].name)
                                .font(.system(size: 14))
                                .bold()
                            Text(viewModel.moves[i].type)
                                .font(.system(size: 14))
                                .underline()
                        }
                        
                        Text(viewModel.moves[i].description)
                            .font(.system(size: 14))
                    }.padding().background(.green).cornerRadius(12).padding()
                }
            }
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
        case PokemonTeamAdditionStatus.fullTeam:
            self.uiMessage = "You can't add more pokemons to your team! You must remove one of them."
        case PokemonTeamAdditionStatus.success:
            self.uiMessage = "Pokemon added to your team!"
        case PokemonTeamAdditionStatus.failed:
            self.uiMessage = "An error ocurred while adding this pokemon to your team."
        default:
            self.uiMessage = "An error ocurred while adding this pokemon to your team."
        }
        
        self.showCommonDialog = true
    }
}

/*
struct PokemonDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailScreen(pokemonId: "1")
    }
}
 */
