//
//  BeforeGamescreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-09.
//

import SwiftUI

struct BeforeGamescreen: View {
    @State private var gameScreenShowing: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Button(action: {
                    Game.practiceMode = true
                    gameScreenShowing.toggle()
                }, label: {
                    Text("Practice mode")
                        .bold()
                        .font(.title3)
                })
                    .frame(width: 250, height: 50)
                    .foregroundColor(Color("ColorWhite"))
                    .background(Color("PrimaryColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("In practice mode your highscore will be saved locally and will not be seen by other players")
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
            }
            .padding()
            .background(Color("ColorWhite"))
            .cornerRadius(10)
            
            Spacer()
                .frame(height: 25)
            
            VStack(spacing: 20) {
                Button(action: {
                    if (Database().checkOnlineGamesLeft()) {
                        Game.practiceMode = false
                        gameScreenShowing.toggle()
                    }
                }, label: {
                    Text("Multiplayer mode")
                        .bold()
                        .font(.title3)
                })
                    .frame(width: 250, height: 50)
                    .foregroundColor(Color("ColorWhite"))
                    .background(Color("PrimaryColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("In multiplayer mode your highscore will be seen by your friends, but you can only play 3 times / day")
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                
                Text("Entries left today:")
                    .italic()
                
                Text("\(Player.user.onlineGamesLeft)")
                    .foregroundColor(Color(.systemRed))
                    .font(.title2)
                    .bold()
            }
            .padding()
            .background(Color("ColorWhite"))
            .cornerRadius(10)
            
            Spacer()
                .frame(height: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("ColorBlack"), Color("ColorGray")]), startPoint: .bottom, endPoint: .top)
        )
        .fullScreenCover(isPresented: $gameScreenShowing, content: {
            Gamescreen()
        })
    }
}

struct BeforeGamescreen_Previews: PreviewProvider {
    static var previews: some View {
        BeforeGamescreen()
    }
}
