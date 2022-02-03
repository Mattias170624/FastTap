//
//  Game.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-01.
//

import Foundation
import SwiftUI

class Game: ObservableObject {
    @Published var userPoints: Int = 0
    @Published var timeLeft: Int = 7
    @State var timer: Timer? = nil
    
    func addGamePoints() {
        userPoints += 1
    }
    
    func startGameClock () {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timeLeft -= 1
            
            if self.timeLeft == 0 {
                print("Stop!!")
            }
        }
    }
    
}
