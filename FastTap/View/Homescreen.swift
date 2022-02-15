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
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.score, order: .reverse)]) var scores: FetchedResults<PracticeScore>
    
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
                    .padding(.bottom, 50)
                
                
                
                VStack {
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
                    
                    Spacer()
                    
                    VStack {
                        Text("Practice score")
                            .font(.title3)
                        
                        List(scores) { item in
                            Text("\(item.score)")
                        }
                        .padding()
                        .frame(width: 300, height: 150)
                        .cornerRadius(10)
                    }
                    
                }
                .frame(height: 300)
                
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
