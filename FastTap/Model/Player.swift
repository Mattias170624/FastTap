//
//  Player.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-01-21.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @State var isLoggedIn: Bool = false
    
    func loginUser() {
        
    }
}

class Player {
    static var nickname: String = ""
    static var email: String = ""
    static var uid: String = ""
    static var onlineScore: Int = 0
    
    
    func listenForUser() {
        
    }
}
