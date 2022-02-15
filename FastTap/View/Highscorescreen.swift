//
//  Highscorescreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-09.
//

import SwiftUI

struct Highscorescreen: View {
    @State private var fetchedFriendsList: [FetchedUser] = []
    @State private var firstPlaceUser: String = " "
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Image(systemName: "crown")
                    .font(.system(size: 120))
                    .foregroundColor(.yellow)
                
                Text("\(firstPlaceUser)")
                    .foregroundColor(Color("ColorWhite"))
                    .italic()
                    .bold()
                    .font(.title)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("PrimaryColor"), lineWidth: 4)
            )
            
            Spacer()
            
            VStack {
                Text("Highscore list")
                    .foregroundColor(Color("ColorWhite"))
                    .bold()
                    .font(.title3)
                    .padding()
            }
            .frame(width: 340)
            .background(Color("PrimaryColor"))
            .cornerRadius(10)
            
            
            List {
                ForEach(Array(fetchedFriendsList.enumerated()), id: \.1.id) { (index, friend) in
                    HStack {
                        Text("\(friend.name)")
                        
                        Spacer()
                        
                        Text("\(friend.score)")
                    }
                    .listRowBackground(Color.white)
                    .padding()
                }
            }
            .frame(width: 340, height: 300)
            .cornerRadius(10)
            
            Spacer()
                .frame(height: 50)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("ColorBlack"), Color("ColorGray")]), startPoint: .bottom, endPoint: .top)
        )
        .onAppear {
            // BUG -> OnAppear triggers when user clicks on textField in loginscreen.
            // auth.currentUser? will have nil, hence why guard is used here to prevent crash
            guard Database().auth.currentUser != nil else { return }
            
            Database().fetchAllFriendsUID { uidList in
                for uid in uidList {
                    Database().fetchFriendsNameAndScore(targetUid: uid) { friend in
                        fetchedFriendsList.append(friend)
                        fetchedFriendsList.sort {
                            $0.score > $1.score
                        }
                        firstPlaceUser = fetchedFriendsList[0].name
                    }
                }
                // Add current user to list
                let user = FetchedUser(name: Player.user.name, uid: "", score: Player.user.score)
                fetchedFriendsList.append(user)
            }
        }
        .onDisappear {
            fetchedFriendsList.removeAll()
        }
    }
}

struct Highscorescreen_Previews: PreviewProvider {
    static var previews: some View {
        Highscorescreen()
    }
}
