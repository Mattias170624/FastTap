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
    @State private var fetchedFriendRequestList: [String] = []
    @State private var friendRequestText = "Friend requests"
    
    var body: some View {
        VStack {
            Button(action: {
                print("!Content: \(fetchedFriendRequestList)")
            }, label: {
                Text("OOO")
            })
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
                            Database().sendFriendRequest(targetUid: user.uid) {
                                print("!Request sent to: \(user.name)")
                            }
                        }, label: {
                            Image(systemName: "plus.square")
                                .foregroundColor(Color(.systemGreen))
                                .font(.system(size: 25))
                        })
                    }
                }
            }
            
            Spacer()
            
            Text(fetchedFriendRequestList.isEmpty ? "No friend requests" : "Active friend requests")
                .font(.title2)
                .padding()
            List {
                ForEach(fetchedFriendRequestList, id: \.self) { user in
                    HStack {
                        Text("\(user)")
                        
                        Spacer()
                        
                        
                    }
                }
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // BUG -> OnAppear triggers when user clicks on textField in loginscreen
            // Hence auth.currentUser? will have nil
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
