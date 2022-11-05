//
//  RoundedCorner.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 5/11/22.
//

import SwiftUI

/*
 Extension to customize views' corners: you can select which corners will have radius applied,
 avoiding to applay it into all of them
 */

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
