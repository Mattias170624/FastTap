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
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor(Color("ColorBlack"))
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color("PrimaryColor"))
    }
    
    var body: some View {
        TabView() {
            VStack {
                Spacer()
                
                VStack {
                    Text("Fast")
                        .fontWeight(.bold)
                        .font(.system(size: 50))
                        .foregroundColor(Color("ColorWhite"))
                    Text("      Tap")
                        .font(.system(size: 50))
                        .foregroundColor(Color("PrimaryColor"))
                }
                .shadow(color: .yellow, radius: 2)
                
                Spacer()
                
                Text("Welcome back!\n\(Player.user.name)")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .frame(width: 200, height: 100)
                    .foregroundColor(Color("ColorBlack"))
                    .background(Color("ColorWhite"))
                    .cornerRadius(10)
                    .padding(.bottom, 50)
                
                Spacer()
                
                HStack {
                    VStack {
                        
                        ZStack {
                            Text("Multiplayer score")
                                .foregroundColor(Color("ColorWhite"))
                                .bold()
                                .padding()
                            
                        }
                        .frame(width: 170)
                        .background(Color("PrimaryColor"))
                        .cornerRadius(10)
                        
                        VStack {
                            Text("\(Player.user.score)")
                                .font(.system(size: 40))
                        }
                        .frame(width: 170, height: 170)
                        .background(Color("ColorWhite"))
                        .cornerRadius(10)
                    }
                    
                    VStack {
                        
                        ZStack {
                            Text("Practice score")
                                .foregroundColor(Color("ColorWhite"))
                                .bold()
                                .padding()
                            
                        }
                        .frame(width: 170)
                        .background(Color("PrimaryColor"))
                        .cornerRadius(10)
                        
                        VStack {
                            List {
                                ForEach(scores) { data in
                                    Text("\(data.score)")
                                        .font(.title3)
                                        .listRowBackground(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        .frame(width: 170, height: 170)
                        .cornerRadius(10)
                    }
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color("ColorBlack"), Color("ColorGray")]), startPoint: .bottom, endPoint: .top)
            )
            .tabItem {
                Label("Home", systemImage: "house")
                    .frame(height: 60)
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
        .accentColor(.red)
    }
}

struct Homescreen_Previews: PreviewProvider {
    static var previews: some View {
        Homescreen()
    }
}
