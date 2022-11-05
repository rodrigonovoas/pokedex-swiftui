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
                            .withNormalTextAndBoldStyle()
                        
                        Text(moves[i].type)
                            .font(.system(size: 12))
                            .foregroundColor(Color.white)
                            .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background(Color(moves[i].type + "TypeColor"))
                            .cornerRadius(12)
                    }
                    .padding(.init(top: 5, leading: 0, bottom: 0, trailing: 0))
                    
                    HStack {
                        Text("Power: ").withNormalTextStyle()
                        Text(moves[i].power.description).withNormalTextStyle()
                        
                        Text("Accuracy: ").withNormalTextStyle()
                        Text(moves[i].accuracy.description).withNormalTextStyle()
                    }
                    
                    Text(moves[i].description)
                        .withNormalTextStyle()
                        .padding(.top, 5)
                }
                .padding()
                .withRoundedCornersAndFullWidthStyle(backgroundColor: Color("startSearchbarGradient"))
                .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
    }
}
