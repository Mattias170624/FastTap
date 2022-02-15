//
//  Registerscreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-05.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Registerscreen: View {
    @State private var termsOfServiceShowing: Bool = false
    @State private var homeScreenShowing: Bool = false
    @State private var showPassword: Bool = false
    @State private var nickname: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    
    var body: some View {
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
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 21, height: 21)
                    .foregroundColor(Color("PrimaryColor"))
                
                TextField("Nickname", text: $nickname)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .foregroundColor(Color("ColorBlack"))
                
                
            }
            .padding()
            .frame(width: 300, height: 50)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("ColorWhite")))
            
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
            
            
            Button(action: {
                registerProcess(email: email, password: password, nickname: nickname) {
                    homeScreenShowing.toggle()
                }
            }, label: {
                Text("Register")
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
            LinearGradient(gradient: Gradient(colors: [Color("ColorBlack"), Color("ColorGray")]), startPoint: .bottom, endPoint: .top)
        )
    }
    
    func registerProcess(email: String, password: String, nickname: String, complete: @escaping() -> Void) {
        Database().registerUser(email: email, password: password, nickname: nickname) {
            Database().assignUserData {
                complete()
            }
        }
    }
}

struct Registerscreen_Previews: PreviewProvider {
    static var previews: some View {
        Registerscreen()
    }
}
