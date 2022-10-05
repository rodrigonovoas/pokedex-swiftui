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

struct PokemonOfficialArtwork: Decodable {
    var front_default: String
}

struct PokemonOther: Decodable {
    var officialArtwork: PokemonOfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct PokemonSprites: Decodable {
    var back_default: String
    var front_default: String
    var other: PokemonOther
}

struct PokemonSpecie: Decodable {
    var flavor_text_entries: [PokemonTextEntries]
}

struct PokemonTextEntries: Decodable {
    var flavor_text: String
}
