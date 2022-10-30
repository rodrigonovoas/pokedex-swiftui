//
//  CommonDialogView.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 29/10/22.
//

import Foundation
import SwiftUI

struct CommonDialogView: View {
    @Binding var message: String
    @Binding var showCommonDialog: Bool
    
    var body: some View {
        VStack {
            Text(message)
                .font(.custom("Pokemon-Pixel-Font", size: 30))
            
            HStack {
                Image("ic_continue")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        showCommonDialog = false
                    }
            }
            
        }
        .padding()
        .background(.white)
        .overlay(
               RoundedRectangle(cornerRadius: 12)
                   .stroke(LinearGradient(gradient: Gradient(colors: [Color("startCommonMessageGradient"), Color("endCommonMessageGradient")]), startPoint: .top, endPoint: .bottom), lineWidth: 8)
           )
        .cornerRadius(12)
    }
}
