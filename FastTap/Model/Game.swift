//
//  Game.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-02-01.
//

import Foundation
import SwiftUI

class Game: ObservableObject {
    static var practiceMode: Bool = true
    @Published var points: Int = 0
    @Published var timeLeft: Int = 10
    @Published var gameTimeOver: Bool = false
    @State var timer: Timer? = nil
    
    func addGamePoints() {
        points += 1
    }
    
    func startGameClock () {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timeLeft -= 1
            self.gameTimeOver = (self.timeLeft <= 0) ? true : false
        }
    }
}
