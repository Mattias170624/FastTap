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
    
    init() {
        if firebaseAuth.currentUser != nil {
            print("Logged in!")
            goToHomeScreen(userUID: firebaseAuth.currentUser!.uid)
        } else {
            print("No user logged in")
        }
    }
    
    
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
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray))
                NavigationLink(destination: RegisterView(), label: {
                    Text("Create an account here")
                })
                
                Button(action: {
                    loginButton()
                }, label: {
                    Text("Login")
                        .frame(width: 250, height: 50, alignment: .center)
                        .font(.title)
                })
                    .buttonStyle(.bordered)
                    .padding(.top, 75)
            }
        }
    }
    
    private func loginButton() {
        if email == "" && password == "" {
            print("Fill in email and password")
        } else {
            
            firebaseAuth.signIn(withEmail: email, password: password) { (result, error) in
                guard (result?.user) != nil else {
                    print("Error logging in")
                    return
                }
                goToHomeScreen(userUID: firebaseAuth.currentUser!.uid)
            }
        }
    }
    
    func goToHomeScreen(userUID: String) {
        print("Home screen")
        
    }
}




struct RegisterView: View {
    var db = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingSheet: Bool = false
    var agreedToTerms: Bool = false
    
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
                    showingSheet.toggle()
                }, label: {
                    Text("By creating an account you agree \n to the terms & conditions")
                        .font(.body)
                        .italic()
                })
            }
            .sheet(isPresented: $showingSheet, content: {
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
                        showingSheet.toggle()
                    }, label: {
                        Text("Dismiss")
                    })
                        .padding(.bottom, 50)
                }
            })
            
            Button(action: {
                registerAccount()
            }, label: {
                Text("Register")
                    .frame(width: 250, height: 50, alignment: .center)
                    .font(.title)
            })
                .buttonStyle(.bordered)
                .padding(.top, 75)
        }
    }
    
    func registerAccount() {
        if nickname == "" || email == "" || password == "" {
            print("Fill in all fields")
        } else {
            firebaseAuth.createUser(withEmail: email, password: password) { (result, error) in
                guard (result?.user) != nil else {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                
                addDataToDatabase(userUID: firebaseAuth.currentUser!.uid)
            }
        }
    }
    
    func addDataToDatabase(userUID: String) {
        let userData = [
            "uid" : firebaseAuth.currentUser!.uid,
            "email" : email,
            "nickname" : nickname]
        
        db.collection("users").document(userUID).setData(userData) { error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            continueToHomeScreen(userUID: userUID)
        }
    }
    
    func continueToHomeScreen(userUID: String) {
        print("Home screen")
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
