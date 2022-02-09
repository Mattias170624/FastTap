//
//  Endscreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-03.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

struct Endscreen: View {
    @State private var backToHomeScreen: Bool = false
    @State private var gameResultText: String = ""
    let firebaseAuth = Auth.auth()
    let points: Int
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("\(Player.user.name)")
                
                Spacer()
                    .frame(height: 25)
                Text("\(points)")
                
                Spacer()
                    .frame(height: 25)
                Text("\(gameResultText)")
            }
            .frame(width: 200, height: 100, alignment: .center)
            .padding()
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title3)
            
            Spacer()
            
            Button(action: {
                Database().assignUserData {
                    backToHomeScreen.toggle()
                }
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
        .onAppear {
            print("!Practicemode: \(Game.practiceMode.description)")
            if points > Player.user.score {
                gameResultText = "You set a new record!"
                Database().updateDataAndAssignNewData(newData: ["onlineScore" : points])
            } else {
                gameResultText = "No new highscore..."
            }
        }
    }
}

struct Endscreen_Previews: PreviewProvider {
    static var previews: some View {
        Endscreen(points: 1)
    }
}
