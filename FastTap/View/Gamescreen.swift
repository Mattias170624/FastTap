//
//  Gamescreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-01.
//

import SwiftUI

struct Gamescreen: View {
    @ObservedObject var game = Game()
    @State var newWidth: Int = 0
    @State var newHeight: Int = 0
    
    var body: some View {
        VStack {
            Button(action: {
                game.addGamePoints()
                changePos()
            }, label: {
                Image(systemName: "hexagon.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color(.systemOrange))
            })
                .position(x: CGFloat(newWidth), y: CGFloat(newHeight))
            
            Spacer()
            
            ZStack {
                HStack {
                    Text("\(Player.user.name)")
                        .padding(20)
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "clock")
                            .font(.system(size: 40))
                        Text("\(game.timeLeft)")
                            .foregroundColor(Color(.systemRed))
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Points")
                        Text("\(game.points)")
                            .foregroundColor(Color.green)
                    }
                    .padding(20)
                }
                .background(Color.white)
                .cornerRadius(15)
                .padding()
                .font(.title3)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
        .fullScreenCover(isPresented: $game.gameTimeOver, content: {
            Endscreen(points: game.points)
        })
        .onAppear(perform: {
            game.startGameClock()
            changePos()
        })
    }
    
    private func changePos() {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        newWidth = Int.random(in: 50..<(Int(screenWidth - 50)))
        newHeight = Int.random(in: 50..<(Int(screenHeight - 250)))
    }
    
}
struct Gamescreen_Previews: PreviewProvider {
    static var previews: some View {
        Gamescreen()
    }
}
