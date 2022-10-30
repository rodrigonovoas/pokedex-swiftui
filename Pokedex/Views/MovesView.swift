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
                            .font(.system(size: 14))
                            .bold()
                        
                        Text(moves[i].type)
                            .font(.system(size: 12))
                            .foregroundColor(Color.white)
                            .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background(Color(moves[i].type + "TypeColor"))
                            .cornerRadius(12)
                    }
                    .padding(.init(top: 5, leading: 0, bottom: 0, trailing: 0))
                    
                    HStack {
                        Text("Power: ").font(.system(size: 14))
                        Text(moves[i].power.description).font(.system(size: 14))
                        
                        Text("Accuracy: ").font(.system(size: 14))
                        Text(moves[i].accuracy.description).font(.system(size: 14))
                    }
                    
                    Text(moves[i].description)
                        .font(.system(size: 14))
                        .padding(.top, 5)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("startSearchbarGradient"))
                .cornerRadius(12)
                .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
    }
}