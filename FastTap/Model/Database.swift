//
//  Database.swift
//  FastTap
//
//  Created by Mattias Andersson on 2022-01-21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

class Database {
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    func loginUserToFirestore(email: String, password: String, complete: @escaping () -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard (result?.user) != nil else {
                print("Error: \(error?.localizedDescription ?? "Logging in")")
                return
            }
            
            complete()
        }
    }
    
    func updateDataAndAssignNewData(newData: [String : Any]) {
        db.collection("users").document(auth.currentUser!.uid).updateData(newData)
        print("!Updated data: \(newData) to firestore!")
    }
    
    func checkOnlineGamesLeft() -> Bool {
        if Player.user.onlineGamesLeft != 0 {
            updateDataAndAssignNewData(newData: ["onlineGamesLeft" : (Player.user.onlineGamesLeft - 1)])
            return true
        } else {
            print("!Player has no online games left!")
            return false
        }
    }
    
    func assignUserData(complete: @escaping() -> Void) {
        db.collection("users").document(auth.currentUser!.uid).getDocument { (document, error) in
            guard let document = document?.data() else { return }
            
            for data in document {
                switch data.key {
                case "nickname":
                    Player.user.name = data.value as! String
                case "onlineScore":
                    Player.user.score = data.value as! Int
                case "onlineGamesLeft":
                    Player.user.onlineGamesLeft = data.value as! Int
                default:
                    break
                }
            }
            complete()
        }
    }
    
    func registerUser(email: String, password: String, nickname: String, complete: @escaping () -> Void) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            guard (result?.user) != nil else {
                print("Error: \(error?.localizedDescription ?? "Regestering")")
                return
            }
            
            let userData: [String : Any] = [
                "onlineGamesLeft" : 3,
                "onlineScore" : 0,
                "email" : email,
                "nickname" : nickname,
                "uid" : result!.user.uid,
            ]
            
            self.db.collection("users").document(result!.user.uid).setData(userData)
            complete()
        }
    }
    
    func logOutUser(complete: @escaping() -> Void) {
        do {
            try auth.signOut()
        } catch {
            print("Error signing out!")
        }
        complete()
    }
    
}
