//
//  Highscorescreen.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-09.
//

import SwiftUI

struct Highscorescreen: View {
    var body: some View {
        VStack {
            Text("Score")
                .font(.title2)
                .padding()
            
            List {
                Text("To be added")
            }
            
            Spacer()
            
        }
    }
}

struct Highscorescreen_Previews: PreviewProvider {
    static var previews: some View {
        Highscorescreen()
    }
}
