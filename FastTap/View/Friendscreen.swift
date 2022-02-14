//
//  Friendscreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-09.
//

import SwiftUI



struct Friendscreen: View {
    @State private var selection = Set<UUID>()
    @State private var fetchedUserList: [FetchedUser] = []
    @State private var fetchedFriendRequestList: [FetchedUser] = []
    @State private var showRequestAlert = false
    
    var body: some View {
        VStack {
            Text("All players")
                .font(.title2)
                .padding()
            
            Spacer()
            
            List {
                ForEach(fetchedUserList) { user in
                    HStack {
                        Text("\(user.name)")
                        
                        Spacer()
                        
                        Text("Add")
                            .foregroundColor(Color(.systemGreen))
                        
                        Button(action: {
                            showRequestAlert = true
                            Database().sendFriendRequest(targetUid: user.uid) {
                                print("!Request sent to: \(user.name)")
                            }
                        }, label: {
                            Image(systemName: "plus.square")
                                .foregroundColor(Color(.systemGreen))
                                .font(.system(size: 25))
                        })
                    }
                    .alert("Friend request sent!", isPresented: $showRequestAlert) {
                        Button("Ok") { }
                    }
                }
            }
            
            Spacer()
            
            Text(fetchedFriendRequestList.isEmpty ? "No friend requests" : "Active friend requests")
                .font(.title2)
                .padding()
            
            
            List {
                ForEach(Array(fetchedFriendRequestList.enumerated()), id: \.1.id) { (index, friend) in
                    HStack {
                        Text(friend.name)
                        
                        Spacer()
                        
                        Button(action: {
                            // Accepts friend request from friend, then removes them from pending friend requests list
                            Database().acceptFriendRequest(targetUid: friend.uid) {
                                Database().removeFriendRequest(targetUid: friend.uid) {
                                    self.fetchedFriendRequestList.remove(at: index)
                                }
                            }
                        }, label: {
                            Text("Accept")
                        })
                    }
                    .padding()
                }
                .onDelete{ index in
                    Database().removeFriendRequest(targetUid: self.fetchedFriendRequestList[index.first!].uid) {
                        self.fetchedFriendRequestList.remove(at: index.first!)
                    }
                }
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // BUG -> OnAppear triggers when user clicks on textField in loginscreen.
            // auth.currentUser? will have nil, hence why guard is used here to prevent crash
            guard Database().auth.currentUser != nil else { return }
            
            Database().getAllUsers { allPlayersList in
                fetchedUserList.append(contentsOf: allPlayersList)
            }
            
            Database().getAllFriendRequests { allFriendRequestList in
                fetchedFriendRequestList.append(contentsOf: allFriendRequestList)
            }
            
        }
        .onDisappear {
            if Database().auth.currentUser != nil {
                fetchedUserList.removeAll()
                fetchedFriendRequestList.removeAll()
            }
        }
    }
}

struct Friendscreen_Previews: PreviewProvider {
    static var previews: some View {
        Friendscreen()
    }
}
