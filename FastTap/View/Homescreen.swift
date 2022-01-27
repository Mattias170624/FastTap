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
    @State private var defaultTabView = 3
    
    
    var body: some View {
        TabView(selection: $defaultTabView) {
            
            Text("Settings Tab")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            
            Text("Score Tab")
                .tabItem {
                    Label("Score", systemImage: "list.bullet")
                }
            
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
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(3)
            
            Text("The Third Tab")
                .tabItem {
                    Label("Play", systemImage: "play.circle")
                }
            
            Text("The Third Tab")
                .tabItem {
                    Label("Players", systemImage: "person.crop.circle.badge.plus")
                }
        }
    }
}

struct Homescreen_Previews: PreviewProvider {
    static var previews: some View {
        Homescreen()
    }
}
