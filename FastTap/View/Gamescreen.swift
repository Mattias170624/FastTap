//
//  Gamescreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-01.
//

import SwiftUI

struct Gamescreen: View {
    var onlineMode: Bool
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    @State var newWidth: Int = 0
    @State var newHeight: Int = 0
    @State var points: Int = 0
    @State var gameHasStarted: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                points += 1
                changePos()
            }, label: {
                Image(systemName: "hexagon.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color(.systemOrange))
            })
                .position(x: CGFloat(newWidth), y: CGFloat(newHeight))
                .opacity(gameHasStarted ? 1 : 0)
            
            Spacer()
            
            ZStack {
                HStack {
                    Text("\(Player.nickname)")
                        .padding(20)
                    
                    Spacer()
                        .frame(width: 75)
                    VStack {
                        Text("Points")
                        Text("\(points)")
                            .foregroundColor(Color.green)
                    }
                    .padding(20)
                }
                .background(Color.blue)
                .cornerRadius(15)
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mint)
        .onAppear(perform: {
            //Todo: add a timer before game starts
            changePos()
            gameHasStarted.toggle()
        })
    }
    
    func changePos() {
        newWidth = Int.random(in: 50..<(Int(screenWidth - 50)))
        newHeight = Int.random(in: 50..<(Int(screenHeight - 250)))
    }
    
}
struct Gamescreen_Previews: PreviewProvider {
    static var previews: some View {
        Gamescreen(onlineMode: true)
    }
}
