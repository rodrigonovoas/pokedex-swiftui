//
//  TextUtils.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 10/10/22.
//

import Foundation

public class TextUtils {
    func removeBlankSpacesFromText(description: String) -> String {
        let descriptionFormatted = description.replacingOccurrences(of: "\n", with: " ")
        return descriptionFormatted.replacingOccurrences(of: "\u{0C}", with: " ")
    }
}
