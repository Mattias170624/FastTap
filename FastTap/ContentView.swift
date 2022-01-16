//
//  ContentView.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-01-16.
//

import SwiftUI

struct ContentView: View {
    @State private var nickname: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            
            Text("Fast \n    Tap")
                .fontWeight(.bold)
                .font(.largeTitle)
                .frame(height: 400)
            
            TextField("Nickname...", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .frame(width: 300, height: 50, alignment: .center)
            
            SecureField("Password...", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300, height: 50, alignment: .center)
            
            Button(action: {
                registerButton()
            }, label: {
                Text("Don't have a account? \n Register here")
                    .font(.caption)
                    .padding()
            })
            
            Button(action: {
                loginButton()
            }, label: {
                Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
            })
                .buttonStyle(.bordered)
                .padding(.top)
            
        }
    }
    
    private func registerButton() {
        print("Register button tapped")
    }
    
    private func loginButton() {
        print("Nickname: \(nickname)")
        print("Password: \(password)")
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
