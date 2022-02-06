//
//  Endscreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-03.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

struct Endscreen: View {
    @State private var backToHomeScreen: Bool = false
    let firebaseAuth = Auth.auth()
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("\(Player.shared.nickname)")
                
                Spacer()
                    .frame(height: 25)
                Text("Score: \(Player.shared.onlinescore)")
            }
            .frame(width: 200, height: 100, alignment: .center)
            .padding()
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title3)
            
            Spacer()
            
            Button(action: {
                backToHomeScreen.toggle()
            }, label: {
                Text("Homescreen")
            })
                .padding()
                .font(.title3)
                .foregroundColor(.white)
                .background(Color(.systemGreen))
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $backToHomeScreen, content: {
            Homescreen()
        })
    }
}

struct Endscreen_Previews: PreviewProvider {
    static var previews: some View {
        Endscreen()
    }
}
