//
//  ContentView.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-01-16.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Loginscreen: View {
    let auth = Auth.auth()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var homeScreenShowing: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Fast \n    Tap")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                Spacer()
                    .frame(height: 150)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    
                    TextField("Email", text: $email)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal)
                .frame(width: 300.0, height: 50.0)
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray))
                
                Spacer()
                    .frame(height: 10)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal)
                .frame(width: 300.0, height: 50.0)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                
                NavigationLink(destination: Registerscreen(), label: {
                    Text("Create an account here")
                })
                
                Button(action: {
                    if email == "" || password == "" {
                        print("Fill in email and password")
                    } else {
                        loginProcess(email: email, password: password) {
                            homeScreenShowing.toggle()
                        }
                    }
                    
                }, label: {
                    Text("Login")
                        .frame(width: 250, height: 50, alignment: .center)
                        .font(.title)
                })
                    .buttonStyle(.bordered)
                    .padding(.top, 75)
                    .fullScreenCover(isPresented: $homeScreenShowing, content: {
                        Homescreen()
                    })
            }
        }
        .fullScreenCover(isPresented: $homeScreenShowing, content: {
            Homescreen()
        })
        .onAppear {
            if auth.currentUser != nil {
                Database().assignUserData {
                    print("!Auto logged user: \(Player.user.name) ")
                    homeScreenShowing.toggle()
                }
            }
        }
    }
    
    func loginProcess(email: String, password: String, complete: @escaping() -> Void) {
        Database().loginUserToFirestore(email: email, password: password) {
            Database().assignUserData {
                complete()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Loginscreen()
    }
}
