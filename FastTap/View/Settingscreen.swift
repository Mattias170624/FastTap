//
//  Settingscreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-09.
//

import SwiftUI

struct Settingscreen: View {
    @State private var loginScreenShowing: Bool = false
    @State private var friendsCount: Int = 0
    @State var darkTheme: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .center) {
                Text("Account settings")
                    .foregroundColor(Color("ColorWhite"))
                    .bold()
                    .font(.title3)
                    .padding()
            }
            .frame(maxWidth: 340, alignment: .center)
            .background(Color("PrimaryColor"))
            .cornerRadius(10)
            
            VStack {
                Form {
                    Section(header: Text("Info")) {
                        HStack {
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("PrimaryColor"))
                            
                            Text("Name:")
                            Spacer()
                            Text("\(Player.user.name)")
                        }
                        
                        HStack {
                            Image(systemName: "envelope")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("PrimaryColor"))
                            
                            Text("Email:")
                            Spacer()
                            Text("\(Player.user.name)")
                        }
                        
                        HStack {
                            Image(systemName: "person.3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("PrimaryColor"))
                            
                            Text("Friends:")
                            Spacer()
                            Text("\(friendsCount)")
                        }
                    }
                    
                    Section(header: Text("")) { }
                    Section(header: Text("")) { }
                    Section(header: Text("")) { }
                    
                    Section(header: Text("Profile")) {
                        Button(action: {
                            Database().logOutUser {
                                loginScreenShowing.toggle()
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color(.systemRed))
                                
                                Text("Sign out")
                                    .foregroundColor(Color(.systemRed))
                            }
                        })
                            .fullScreenCover(isPresented: $loginScreenShowing, content: {
                                Loginscreen()
                            })
                    }
                }
            }
            .frame(width: 340, height: 480)
            .cornerRadius(10)
            
            Spacer()
                .frame(height: 50)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("ColorBlack"), Color("ColorGray")]), startPoint: .bottom, endPoint: .top)
        )
        .onAppear(perform: {
            guard Database().auth.currentUser != nil else { return }
            
            Database().fetchAllFriendsUID { listOfFriends in
                friendsCount = listOfFriends.count
            }
        })
    }
}

struct Settingscreen_Previews: PreviewProvider {
    static var previews: some View {
        Settingscreen()
    }
}
