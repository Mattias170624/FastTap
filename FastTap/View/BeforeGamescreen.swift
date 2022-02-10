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
            Text("Play")
                .font(.title2)
                .padding()
            
            Spacer()
            
            VStack(spacing: 20) {
                Button("Practice mode") {
                    Game.practiceMode = true
                    gameScreenShowing.toggle()
                }
                .padding()
                .font(.title3)
                .foregroundColor(.white)
                .background(Color(.systemGreen))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("In practice mode your highscore will be saved locally and will not be seen by other players")
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            
            Spacer()
                .frame(height: 25)
            
            VStack(spacing: 20) {
                Button("Multiplayer mode") {
                    if (Database().checkOnlineGamesLeft()) {
                        Game.practiceMode = false
                        gameScreenShowing.toggle()
                    }
                }
                .padding()
                .font(.title3)
                .foregroundColor(.white)
                .background(Color(.systemGreen))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text("In multiplayer mode your highscore will be seen by your friends, but you can only play 3 times / day")
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                
                Text("Entries left today:")
                    .italic()
                
                Text("\(Player.user.onlineGamesLeft)")
                    .foregroundColor(Color(.systemRed))
                    .bold()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            
            Spacer()
        }
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
