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
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color("ColorWhite"))
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            List {
                ZStack(alignment: .center) {
                    Text("All game users")
                        .foregroundColor(Color("ColorWhite"))
                        .bold()
                        .font(.title3)
                        .padding()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color("PrimaryColor"))
                .cornerRadius(5)
                
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
                            Image(systemName: "person.badge.plus")
                                .foregroundColor(Color(.systemGreen))
                                .font(.system(size: 25))
                        })
                    }
                    .alert("Friend request sent!", isPresented: $showRequestAlert) {
                        Button("Ok") { }
                    }
                    .listRowBackground(Color.white)
                }
            }
            .frame(width: 340, height: 300)
            .cornerRadius(10)
            
            Spacer()
            
            List {
                ZStack(alignment: .center) {
                    Text(fetchedFriendRequestList.isEmpty ? "No friend requests" : "Active friend requests")
                        .foregroundColor(Color("ColorWhite"))
                        .bold()
                        .font(.title3)
                        .padding()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color("PrimaryColor"))
                .cornerRadius(5)
                
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
                                .foregroundColor(Color.green)
                        })
                    }
                    .listRowBackground(Color.white)
                    .padding()
                }
                .onDelete{ index in
                    Database().removeFriendRequest(targetUid: self.fetchedFriendRequestList[index.first!].uid) {
                        self.fetchedFriendRequestList.remove(at: index.first!)
                    }
                }
            }
            .frame(width: 340, height: 300)
            .cornerRadius(10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("ColorBlack"), Color("ColorGray")]), startPoint: .bottom, endPoint: .top)
        )
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
