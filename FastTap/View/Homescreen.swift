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
    @State private var loginScreenShowing: Bool = false
    @State private var gameScreenShowing: Bool = false
    @State private var nicknameSearch: String = ""
    @State private var selectedTabView = 3
    @State var darkTheme: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTabView) {
            VStack {
                Text("Settings")
                    .font(.title2)
                    .padding()
                
                Form {
                    Section(header: Text("Themes")) {
                        Toggle(isOn: $darkTheme, label: {
                            Text("Dark theme")
                        })
                    }
                    
                    Section(header: Text("Profile")) {
                        Button(action: {
                            Database().logOutUser {
                                loginScreenShowing.toggle()
                            }
                        }, label: {
                            Text("Sign out")
                                .foregroundColor(Color(.systemRed))
                        })
                            .fullScreenCover(isPresented: $loginScreenShowing, content: {
                                Loginscreen()
                            })
                    }
                }
                Spacer()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            
            VStack {
                Text("Score")
                    .font(.title2)
                    .padding()
                
                List {
                    Text("To be added")
                }
                
                Spacer()
                
            }
            .tabItem {
                Label("Score", systemImage: "list.bullet")
            }
            
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
            .tag(3)
            
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
            .tabItem {
                Label("Play", systemImage: "play.circle")
            }
            
            VStack {
                Text("Friends")
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                Text("You can find a friend by searching\nfor their nickname down below")
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)
                
                Spacer()
                    .frame(height: 50)
                
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    
                    TextField("Nickname", text: $nicknameSearch)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    
                    Button(action: {
                        print("Added: \(nicknameSearch)")
                    }, label: {
                        Text("Add")
                            .foregroundColor(Color(.systemGreen))
                    })
                }
                .padding(.horizontal)
                .frame(width: 300.0, height: 50.0)
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray))
                
                Spacer()
            }
            .tabItem {
                Label("Friends", systemImage: "person.crop.circle.badge.plus")
            }
        }
    }
}

struct Homescreen_Previews: PreviewProvider {
    static var previews: some View {
        Homescreen()
    }
}
