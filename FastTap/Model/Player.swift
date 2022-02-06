//
//  Player.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-01-21.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

class Player: ObservableObject {
    private var db = Firestore.firestore()
    private var firebaseAuth = Auth.auth()
    
    @Published var onlinescore: Int = 0
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var uid: String = ""
    static let shared = Player()
    
    
    func listenToUserdata(uid: String, complete: @escaping () -> Void) {
        db.collection("users").document(uid).addSnapshotListener { (querysnapshot, error) in
            guard let documents = querysnapshot?.data() else {
                print("No data to listen to")
                return
            }
            
            for item in documents {
                switch item.key {
                case "email":
                    Player.shared.email = item.value as! String
                case "nickname":
                    Player.shared.nickname = item.value as! String
                case "uid":
                    Player.shared.uid = item.value as! String
                case "onlineScore":
                    Player.shared.onlinescore = item.value as! Int
                default:
                    break
                }
            }
            print("Player data updated!")
            complete()
        }
    }
}
