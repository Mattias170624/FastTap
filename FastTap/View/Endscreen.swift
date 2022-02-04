//
//  Endscreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-03.
//

import SwiftUI

struct Endscreen: View {
    var points: Int
    @State private var backToHomeScreen: Bool = false
    
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("\(Player.nickname)")
                
                Spacer()
                    .frame(height: 25)
                Text("Score: \(points)")
            }
            .frame(width: 200, height: 100, alignment: .center)
            .padding()
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title3)
            
            Spacer()
            
            Button(action: {
                backToHomeScreen.toggle()
            }, label: {
                Text("Homescreen")
            })
                .padding()
                .font(.title3)
                .foregroundColor(.white)
                .background(Color(.systemGreen))
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $backToHomeScreen, content: {
            Homescreen()
        })
        .onAppear(perform: {
            //Todo:
            //Check if highscore is higher than the one before, if true, display additional text
        })
    }
    
}

struct Endscreen_Previews: PreviewProvider {
    static var previews: some View {
        Endscreen(points: 9)
    }
}
