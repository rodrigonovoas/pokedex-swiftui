//
//  PokemonSpecie.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 27/9/22.
//

import Foundation

struct PokemonSpecies: Decodable {
    var name: String
    var url: String
}

struct PokemonBlackWhite: Decodable {
    var back_default: String
    var front_default: String
}

struct PokemonGenerationV: Decodable {
    var blackWhite: PokemonBlackWhite
    
    enum CodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }
}

struct PokemonVersions: Decodable {
    var generationV: PokemonGenerationV
    
    enum CodingKeys: String, CodingKey {
        case generationV = "generation-v"
    }
}

struct PokemonSprites: Decodable {
    var back_default: String
    var front_default: String
    var versions: PokemonVersions
}

struct PokemonSpecie: Decodable {
    var flavor_text_entries: [PokemonTextEntries]
}

struct PokemonTextEntries: Decodable {
    var flavor_text: String
}
