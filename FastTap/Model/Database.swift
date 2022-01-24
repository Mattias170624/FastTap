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
    
    func fetchUserInformation(userUID: String, completion: @escaping((Bool) -> ())) {
        self.db.collection("users").document(userUID).getDocument { document, error in
            guard document?.data() != nil else {
                print("Error fetching document: \(error!.localizedDescription)")
                return
            }
            let playerData = document!.data()
            
            for item in playerData! {
                switch item.key {
                case "email":
                    Player.email = item.value as! String
                case "nickname":
                    Player.nickname = item.value as! String
                case "uid":
                    Player.uid = item.value as! String
                case "onlineScore":
                    Player.onlineScore = item.value as! Int
                default:
                    break
                }
            }
            completion(true)
        }
    }
    
    func addFirestoreUserData(email: String, password: String, nickname: String, completion: @escaping((Bool) -> ())) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            guard (result?.user) != nil else {
                print("Error registering: \(error!.localizedDescription)")
                return
            }
            
            let userData: [String : Any] = [
                "onlineScore" : 0,
                "uid" : result!.user.uid,
                "email" : email,
                "nickname" : nickname]
            
            
            self.db.collection("users").document(result!.user.uid).setData(userData)
            completion(true)
        }
    }
    
    func loginUserToFirestore(email: String, password: String, completion: @escaping((Bool) -> ())) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard (result?.user) != nil else {
                print("Error logging in: \(error!.localizedDescription)")
                return
            }
            
            self.fetchUserInformation(userUID: result!.user.uid) { Bool in
                completion(true)
            }
        }
    }
}
