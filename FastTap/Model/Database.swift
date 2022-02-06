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
    
    
    func addFirestoreUserData(email: String, password: String, nickname: String, complete: @escaping () -> Void) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            guard (result?.user) != nil else {
                print("Error: \(error?.localizedDescription ?? "Regestering")")
                return
            }
            
            let userData: [String : Any] = [
                "onlineScore" : 0,
                "uid" : result!.user.uid,
                "email" : email,
                "nickname" : nickname]
            
            self.db.collection("users").document(result!.user.uid).setData(userData)
            complete()
        }
    }
    
    func loginUserToFirestore(email: String, password: String, complete: @escaping () -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard (result?.user) != nil else {
                print("Error: \(error?.localizedDescription ?? "Logging in")")
                return
            }
            
            complete()
        }
    }
}
