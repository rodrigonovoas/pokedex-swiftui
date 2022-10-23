//
//  PokemonSpecie.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 27/9/22.
//

import Foundation

// MARK: - Pokemon List
/// # Pokemon List from API
public struct PokemonListResponse: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonResponse]?
}

public struct PokemonResponse: Identifiable, Codable {
    public var id = UUID()
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

// MARK: - Pokemon Detail
/// # Pokemon List from API
public struct PokemonDetailResponse: Decodable, Identifiable {
    public var id = UUID()
    var name: String
    var order: Int
    var species: PokemonSpecies
    var sprites: Sprites
    var types: [PokemonTypes]
    var abilities: [PokemonAbilities]
    var stats: [PokemonStats]
    var moves: [PokemonMoves]
    var weight: Int
    var height: Int
    
    enum CodingKeys: String, CodingKey {
        case name, order, sprites, species, types, abilities, stats, moves, weight, height
    }
}

/// # Specie
public struct PokemonSpecies: Decodable {
    var name: String
    var url: String
}

/// # Types
public struct PokemonTypes: Decodable {
    var slot: Int
    var type: PokemonSpecies
}

/// # Sprites
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


/// # Abilities
public struct PokemonAbilities: Decodable {
    var ability: PokemonAbility
    var isHidden: Bool
    var slot: Int
    
    enum CodingKeys: String, CodingKey {
        case ability, isHidden = "is_hidden", slot
    }
}

public struct PokemonAbility: Decodable {
    var name: String
    var url: String
}

/// # Stats
public struct PokemonStats: Decodable {
    var baseStat: Int
    var stat: PokemonStat
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat", stat
    }
}

public struct PokemonStat: Decodable {
    var name: String
    var url: String
}

/// # Moves
public struct PokemonMoves: Decodable {
    var move: PokemonMove
}

public struct PokemonMove: Decodable {
    var name: String
    var url: String
}
// MARK: - Pokemon Specie from API
/// # Pokemon Specie Response
public struct PokemonSpecieResponse: Decodable {
    var flavor_text_entries: [TextEntries]
}

/// # Pokemon text entries
public struct TextEntries: Decodable {
    var flavor_text: String
}

// MARK: - Pokemon Movements from API
/// # Pokemon Move Response
public struct PokemonMoveResponse: Decodable {
    var effectEntries: [EffectEntries]
    var type: PokemonAbility
    
    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries", type
    }
}

/// # Pokemon text entries
public struct EffectEntries: Decodable {
    var shortEffect: String
    
    enum CodingKeys: String, CodingKey {
        case shortEffect = "short_effect"
    }
}
