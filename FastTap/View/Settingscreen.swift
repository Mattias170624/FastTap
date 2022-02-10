//
//  Settingscreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-09.
//

import SwiftUI

struct Settingscreen: View {
    @State private var loginScreenShowing: Bool = false
    @State var darkTheme: Bool = false

    var body: some View {
        VStack {
            Text("Settings")
                .font(.title2)
                .padding()
            
            Form {
                Section(header: Text("Themes")) {
                    Toggle(isOn: $darkTheme, label: {
                        Text("Dark theme")
                    })
                }
                
                Section(header: Text("Profile")) {
                    Button(action: {
                        Database().logOutUser {
                            loginScreenShowing.toggle()
                        }
                    }, label: {
                        Text("Sign out")
                            .foregroundColor(Color(.systemRed))
                    })
                        .fullScreenCover(isPresented: $loginScreenShowing, content: {
                            Loginscreen()
                        })
                }
            }
            Spacer()
        }
    }
}

struct Settingscreen_Previews: PreviewProvider {
    static var previews: some View {
        Settingscreen()
    }
}
