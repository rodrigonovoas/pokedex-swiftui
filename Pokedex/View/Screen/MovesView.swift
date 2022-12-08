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
        Text("Moves").bold().font(.system(size: 26))
        
        ScrollView {
            ForEach(0..<moves.count, id: \.self) { i in
                VStack {
                    HStack{
                        Text(moves[i].name.capitalized)
                            .underline()
                            .bold()
                            .font(.system(size: 18))
                        
                        Image("ic_power").resizable().frame(width: 15, height: 15)
                        Text(moves[i].power.description).withNormalTextStyle()
                        
                        Image("ic_accuracy").resizable().frame(width: 15, height: 15)
                        Text(moves[i].accuracy.description).withNormalTextStyle()
                    }
                    
                    Text(moves[i].description)
                        .withNormalTextStyle()
                        .padding(.top, 2)
                }
                .padding(.init(top: 10, leading: 20, bottom: 20, trailing: 20))
                .withRoundedCornersAndFullWidthStyle(backgroundColor: Color(BgColorUtils.getPokemonTypeBackgroundColor(type: moves[i].type)))
                .shadow(radius: 2)
                .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
    }
}
