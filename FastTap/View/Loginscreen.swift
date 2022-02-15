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
    @State private var showPassword: Bool = false
    
    var body: some View {
        NavigationView {
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
                
                Spacer()
                    .frame(height: 200)
        
                    
                
                HStack {
                    Image(systemName: "envelope")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color("PrimaryColor"))
                    
                    TextField("Email", text: $email)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .foregroundColor(Color("ColorBlack"))
                    
                    
                }
                .padding()
                .frame(width: 300, height: 50)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("ColorWhite")))
                
                HStack {
                    Image(systemName: "lock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color("PrimaryColor"))
                    
                    if showPassword {
                        TextField("Password", text: $password)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .foregroundColor(Color("ColorBlack"))
                    } else {
                        SecureField("Password", text: $password)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .foregroundColor(Color("ColorBlack"))
                    }
                    
                    Button(action: {
                        self.showPassword.toggle()
                    }, label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundColor(Color("ColorGray"))
                    })
                    
                }
                .padding()
                .frame(width: 300, height: 50)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("ColorWhite")))
                
                
                
                NavigationLink(destination: Registerscreen(), label: {
                    Text("Create an account here")
                })
                
                Spacer()
                
                Button(action: {
                    loginProcess(email: email, password: password) {
                        print("!Logging in user: \(Player.user.name)")
                        homeScreenShowing.toggle()
                    }
                }, label: {
                    Text("Login")
                        .bold()
                        .frame(width: 275, height: 60, alignment: .center)
                        .font(.title)
                })
                    .foregroundColor(Color("ColorWhite"))
                    .background(Color("PrimaryColor"))
                    .cornerRadius(10)
                    .padding(.top, 75)
                    .fullScreenCover(isPresented: $homeScreenShowing, content: {
                        Homescreen()
                    })
                
               Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color("AdaptiveGradient1"), Color("AdaptiveGradient2")]), startPoint: .bottom, endPoint: .top)
            )
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
        guard email != "" || password != "" else { return }
        
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
