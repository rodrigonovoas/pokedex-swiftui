//
//  PokemonSpecie.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 27/9/22.
//

import Foundation

public struct PokemonListResponse: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Pokemon]?
}

public struct Pokemon: Identifiable, Codable {
    public var id = UUID()
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

public struct PokemonDetailResponse: Decodable, Identifiable {
    public var id = UUID()
    var name: String
    var order: Int
    var species: PokemonSpecies
    var sprites: Sprites
    
    enum CodingKeys: String, CodingKey {
        case name, order, sprites, species
    }
}

public struct PokemonSpecies: Decodable {
    var name: String
    var url: String
}

public struct OfficialArtwork: Decodable {
    var front_default: String
}

public struct Other: Decodable {
    var officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

public struct Sprites: Decodable {
    var back_default: String
    var front_default: String
    var other: Other
}

public struct PokemonSpecieResponse: Decodable {
    var flavor_text_entries: [TextEntries]
}

public struct TextEntries: Decodable {
    var flavor_text: String
}
