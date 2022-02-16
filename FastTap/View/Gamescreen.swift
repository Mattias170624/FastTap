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
            VStack {
                Circle()
                    .fill(Color("ColorBlack"))
                    .frame(width: 75, height: 75)
                    .overlay(
                        Image(systemName: "clock.fill")
                            .font(.system(size: 65))
                            .foregroundColor(.white)
                    )
                
                Text("\(game.timeLeft)")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.red)
                    .shadow(color: .red, radius: 3)

            }
            
            Button(action: {
                game.addGamePoints()
                changePos()
            }, label: {
                Image(systemName: "line.3.crossed.swirl.circle.fill")
                    .shadow(color: .red, radius: 2)
                    .font(.system(size: 60))
                    .foregroundColor(Color("PrimaryColor"))
                    .background(Color("ColorBlack"))
                    .cornerRadius(50)
            })
                .position(x: CGFloat(newWidth), y: CGFloat(newHeight))
            
            Spacer()
            
            HStack {
                Spacer()
                ZStack {
                    Text("\(Player.user.name)")
                }
                .padding()
                .background(Color("ColorWhite"))
                .cornerRadius(10)
                .font(.title3)
                
                Spacer()
                
                ZStack {
                    Text("\(game.points)")
                }
                .frame(width: 25, height: 25)
                .padding()
                .background(Color("ColorWhite"))
                .cornerRadius(10)
                .font(.title3)
                
                Spacer()

            }
            .frame(maxWidth: 340, maxHeight: 80)
            .background(Color("PrimaryColor"))
            .cornerRadius(10)
            .font(.title3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("ColorBlack"), Color("ColorGray")]), startPoint: .bottom, endPoint: .top)
        )
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
        newHeight = Int.random(in: 50..<(Int(screenHeight - 365)))
    }
    
}
struct Gamescreen_Previews: PreviewProvider {
    static var previews: some View {
        Gamescreen()
    }
}
