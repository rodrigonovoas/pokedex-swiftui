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
                        Image("ic_move_detail").resizable().frame(width: 30, height: 30)
                        
                        Text(moves[i].name.capitalized)
                            .underline()
                            .bold()
                            .font(.system(size: 18))
                        
                        Text(moves[i].type)
                            .font(.system(size: 12))
                            .foregroundColor(Color.white)
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
