//
//  Move.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 15/11/22.
//

import Foundation

public struct Move: Identifiable {
    public var id = UUID()
    var name: String
    var type: String
    var accuracy: Int
    var power: Int
    var description: String
}
