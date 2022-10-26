//
//  PokemonTeamHelper.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 26/10/22.
//

import Foundation

public class PokemonTeamHelper {
    
    let key = "POKEMON_TEAM_POKEDEX"
    
    public func getTeamFromLocalCache() -> [PokemonTeam] {
        if let cachedPokemons = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let pokemons = try decoder.decode([PokemonTeam].self, from: cachedPokemons)
                
                print("DEBUG-- getPokemonFromLocalCache retrieved pokes: " + pokemons.description)
                
                return pokemons
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        
        return []
    }
    
    public func deletePokemon(pokemonName: String, currentTeam: [PokemonTeam]) -> [PokemonTeam] {
        var position = 0
        
        for pokemon in currentTeam {
            if(pokemon.name == pokemonName) {
                break
            }
            position += 1
        }
        
        if(position >= currentTeam.count) { return [] }

        var updatedTeam = currentTeam
        updatedTeam.remove(at: position)
        
        updatePokemonList(pokemonList: updatedTeam)
        
        return updatedTeam
    }
    
    private func updatePokemonList(pokemonList: [PokemonTeam]){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(pokemonList)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Unable to Encode Array of Pokemon (\(error))")
        }
    }
    
    public func addPokemonToTeamList(pokemonName: String, pokemonImage: String) -> Bool {
        var pokes = getTeamFromLocalCache()
        
        if(pokes.count < 6){
            do {
                pokes.append(PokemonTeam(name: pokemonName, imageUrl: pokemonImage))
                let encoder = JSONEncoder()
                let data = try encoder.encode(pokes)
                UserDefaults.standard.set(data, forKey: key)
                return true
            } catch {
                print("Unable to Encode Array of Pokemon (\(error))")
                return false
            }
        } else {
            print("DEBUG-- YOU CAN'T ADD MORE POKEMONS!")
            return false
        }
    }
}
