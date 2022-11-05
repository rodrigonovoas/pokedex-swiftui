//
//  Extensions.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 2/11/22.
//

import SwiftUI

extension View {
    func withRoundedCornersAndFullWidthStyle(backgroundColor: Color) -> some View {
        self.frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(12)
    }
    
    func withRoundedCornersAndPadding(backgroundColor: Color) -> some View {
        self.padding()
            .background(backgroundColor)
            .cornerRadius(12)
    }
    
    func withGradientBackgroundStyle(startColor: String, endColor: String) -> some View {
        self.background(LinearGradient(gradient: Gradient(colors: [Color(startColor), Color(endColor)]), startPoint: .top, endPoint: .bottom))
    }
}

extension Text {
    func withNormalTextStyle() -> some View  {
        self.font(.system(size: 14))
    }
    
    func withNormalTextAndUnderlinedStyle() -> some View  {
        self.font(.system(size: 14))
            .underline()
    }
    
    func withNormalTextAndBoldStyle() -> some View  {
        self.font(.system(size: 14))
            .bold()
    }
    
    func withCustomFont(size: CGFloat) -> some View  {
        self.font(.custom("Pokemon-Pixel-Font", size: size))
    }
}
