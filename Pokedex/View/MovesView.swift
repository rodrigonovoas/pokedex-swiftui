//
//  MovesView.swift
//  Pokedex
//
//  Created by Rodrigo Novoa Salgado on 29/10/22.
//

import SwiftUI

struct MovesView: View {
    @State var moves: [Move] = []
    var body: some View {
        Text("Moves").font(.system(size: 22))
        
        ScrollView {
            ForEach(0..<moves.count, id: \.self) { i in
                VStack {
                    HStack{
                        Text(moves[i].name)
                            .underline()
                            .withNormalTextAndBoldStyle()
                        
                        Text(moves[i].type)
                            .font(.system(size: 12))
                            .foregroundColor(Color.white)
                            // .background(Color(moves[i].type + "TypeColor"))
                            // .cornerRadius(12)
                    }
                    
                    HStack {
                        Text("Power: ").withNormalTextAndBoldStyle()
                        Text(moves[i].power.description).withNormalTextStyle()
                        
                        Text("Accuracy: ").withNormalTextAndBoldStyle()
                        Text(moves[i].accuracy.description).withNormalTextStyle()
                    }
                    .padding(.top, 2)
                    
                    Divider()
                    
                    Text(moves[i].description)
                        .withNormalTextStyle()
                        .padding(.top, 2)
                }
                .padding(.init(top: 10, leading: 20, bottom: 20, trailing: 20))
                .withRoundedCornersAndFullWidthStyle(backgroundColor: Color(moves[i].type + "TypeColor"))
                .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
    }
}
