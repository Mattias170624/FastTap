//
//  ContentView.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-01-16.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    var db = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
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
                
                NavigationLink(destination: RegisterView(), label: {
                    Text("Create an account here")
                })
                
                Button(action: {
                    if email == "" || password == "" {
                        print("Fill in email and password")
                    } else {
                        Database().loginUserToFirestore(email: email, password: password, completion: { Bool in
                            print("Logged in with \(Player.nickname)")
                            homeScreenShowing.toggle()
                        })
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
        .onAppear(perform: {
            if firebaseAuth.currentUser != nil {
                Database().fetchUserInformation(userUID: firebaseAuth.currentUser!.uid) { Bool in
                    homeScreenShowing.toggle()
                }
            } else {
                print("No user logged in")
            }
        })
        .fullScreenCover(isPresented: $homeScreenShowing, content: {
            Homescreen()
        })
    }
    
}





struct RegisterView: View {
    var db = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var termsOfServiceShowing: Bool = false
    @State private var homeScreenShowing: Bool = false
    private var agreedToTerms: Bool = false
    
    var body: some View {
        VStack {
            Text("Fast \n    Tap")
                .fontWeight(.bold)
                .font(.largeTitle)
                .navigationTitle("Register").navigationBarTitleDisplayMode(.inline)
            
            Spacer()
                .frame(height: 150)
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                
                TextField("Nickname", text: $nickname)
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
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray))
            
            HStack {
                Button(action: {
                    termsOfServiceShowing.toggle()
                }, label: {
                    Text("By creating an account you agree \n to the terms & conditions")
                        .font(.body)
                        .italic()
                })
            }
            .sheet(isPresented: $termsOfServiceShowing, content: {
                VStack {
                    Text("License Agreement")
                        .font(.title)
                        .padding(50)
                    
                    Spacer()
                    
                    Text("1: Everyone can add you to their friendlist \nwhen you create an account")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                    
                    Spacer()
                    
                    Button(action: {
                        termsOfServiceShowing.toggle()
                    }, label: {
                        Text("Dismiss")
                    })
                        .padding(.bottom, 50)
                }
            })
            
            Button(action: {
                if nickname == "" || email == "" || password == "" {
                    print("Fill in all fields")
                } else {
                    registerAccount()
                }
            }, label: {
                Text("Register")
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
    
    func registerAccount() {
        Database().addFirestoreUserData(email: email, password: password, nickname: nickname) { Bool in
            Database().fetchUserInformation(userUID: firebaseAuth.currentUser!.uid) { Bool in
                homeScreenShowing.toggle()
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
