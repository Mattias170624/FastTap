//
//  Highscorescreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-09.
//

import SwiftUI

struct Highscorescreen: View {
    @State private var fetchedFriendsList: [FetchedUser] = []
    
    var body: some View {
        VStack {
            Text("Score")
                .font(.title2)
                .padding()
            
            List {
                ForEach(fetchedFriendsList) { friend in
                    
                    HStack {
                        Text("\(friend.name)")
                        
                        Spacer()
                        
                        Text("\(friend.score)")
                    }
                }
            }
            
            Spacer()
            
        }
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
