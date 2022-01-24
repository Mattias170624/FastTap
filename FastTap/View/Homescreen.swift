//
//  Homescreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-01-24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Homescreen: View {
    let firebaseAuth = Auth.auth()
    @State private var backToStartScreen: Bool = false

    
    var body: some View {
        VStack {
            Text("Fast \n    Tap")
                .fontWeight(.bold)
                .font(.largeTitle)
            
            Spacer()
                .frame(height: 50)
            
            Text("Welcome back")
                .font(.headline)
            
            Text("\(Player.nickname)!")
                .italic()
            
            Spacer()
                .frame(height: 150)
            
            Text("Practice score:")
            Text("\(Player.onlineScore)")
                .foregroundColor(.green)
            
            Text("Multiplayer score:")
            Text("X")
                .foregroundColor(.green)
            
            //  Temporary signout button
            Button(action: {
                do {
                    try firebaseAuth.signOut()
                    backToStartScreen.toggle()
                } catch {
                    print("Error signing out")
                }
            }, label: {
                Text("sign out")
            })
                .fullScreenCover(isPresented: $backToStartScreen, content: {
                ContentView()
            })
        }
    }
}

struct Homescreen_Previews: PreviewProvider {
    static var previews: some View {
        Homescreen()
    }
}
