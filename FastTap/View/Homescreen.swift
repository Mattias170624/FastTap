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
    
    var body: some View {
        TabView() {
            
            VStack {
                Text("Fast \n    Tap")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                Spacer()
                    .frame(height: 50)
                
                Text("Welcome back!\n\(Player.user.name)")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .frame(width: 200, height: 100)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)
                
                Spacer()
                    .frame(height: 250)
                
                HStack {
                    VStack {
                        Text("Practice score")
                            .font(.title3)
                        Text("0")
                            .foregroundColor(.green)
                            .font(.title2)
                            .bold()
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)
                    
                    VStack {
                        Text("Online score")
                            .font(.title3)
                        Text("\(Player.user.score)")
                            .foregroundColor(.green)
                            .font(.title2)
                            .bold()
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            
            Highscorescreen()
                .tabItem {
                    Label("Score", systemImage: "list.bullet")
                }
            
            BeforeGamescreen()
                .tabItem {
                    Label("Play", systemImage: "play.circle")
                }
            
            Friendscreen()
                .tabItem {
                    Label("Friends", systemImage: "person.crop.circle.badge.plus")
                }
            
            Settingscreen()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct Homescreen_Previews: PreviewProvider {
    static var previews: some View {
        Homescreen()
    }
}
