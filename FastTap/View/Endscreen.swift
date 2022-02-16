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
    @Environment(\.managedObjectContext) var moc
    
    @State private var backToHomeScreen: Bool = false
    @State private var gameResultText: String = ""
    let firebaseAuth = Auth.auth()
    let points: Int
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Text("\(gameResultText)")
                    .bold()
                    .font(.title3)
                
            }
            .frame(width: 340, height: 50)
            .background(Color("PrimaryColor"))
            .cornerRadius(10)
            .foregroundColor(Color("ColorWhite"))
            
            HStack {
                Spacer()
                
                VStack {
                    Text("Score")
                        .font(.system(size: 20))
                        .foregroundColor(Color("ColorWhite"))
                        .padding()
                    
                    Text("\(points)")
                        .font(.system(size: 25))
                        .foregroundColor(Color("PrimaryColor"))
                        .bold()
                    
                }
                .frame(width: 100, height: 150)
                .background(Color("ColorGray"))
                .cornerRadius(10)
                
                Image(systemName: (Player.user.score < points) ? "greaterthan.square.fill" : "lessthan.square.fill")
                    .font(.system(size: 70))
                    .foregroundColor(Color("PrimaryColor"))
                
                VStack {
                    VStack {
                        Text("High")
                            .font(.system(size: 20))
                            .foregroundColor(Color("ColorWhite"))
                        
                        Text("score")
                            .font(.system(size: 20))
                            .foregroundColor(Color("ColorWhite"))
                    }
                    .padding(5)
                    
                    Text("\(Player.user.score)")
                        .font(.system(size: 25))
                        .foregroundColor(Color("PrimaryColor"))
                        .bold()
                }
                .frame(width: 100, height: 150)
                .background(Color("ColorGray"))
                .cornerRadius(10)
                
                Spacer()
                
            }
            .frame(width: 340, height: 200)
            .background(Color("ColorWhite"))
            .cornerRadius(10)
            
            Spacer()
                .frame(height: 150)
            
            Button(action: {
                if Game.practiceMode == false {
                    Database().assignUserData {
                        backToHomeScreen.toggle()
                    }
                } else {
                    backToHomeScreen.toggle()
                }
            }, label: {
                Text("Homescreen")
                    .foregroundColor(Color("ColorWhite"))
                    .bold()
                    .font(.title3)
                    .padding()
            })
                .frame(maxWidth: 250, alignment: .center)
                .background(Color("PrimaryColor"))
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("ColorBlack"), Color("ColorGray")]), startPoint: .bottom, endPoint: .top)
        )
        .fullScreenCover(isPresented: $backToHomeScreen, content: {
            Homescreen()
        })
        .onAppear {
            guard Database().auth.currentUser != nil else { return }
            
            switch Game.practiceMode {
            case true:
                gameResultText = "You did your best!"
                let int32Score = Int32(points)
                let newSave = PracticeScore(context: moc)
                newSave.score = int32Score
                try? moc.save()
                
            case false:
                if points > Player.user.score {
                    gameResultText = "You set a new record!"
                    Database().updateDataAndAssignNewData(newData: ["onlineScore" : points])
                } else {
                    gameResultText = "No new highscore..."
                }
            }
        }
    }
}

struct Endscreen_Previews: PreviewProvider {
    static var previews: some View {
        Endscreen(points: 1)
    }
}
