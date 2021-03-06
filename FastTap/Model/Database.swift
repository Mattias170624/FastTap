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

struct FetchedUser: Identifiable {
    let name: String
    let uid: String
    let score: Int
    let id = UUID()
}


class Database {
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    
    func removeFriendRequest(targetUid: String, complete: @escaping() -> Void) {
        db.collection("users").document(auth.currentUser!.uid).collection("friendRequest").document(targetUid).delete { (error) in
            if let error = error {
                print("!Error: \(error.localizedDescription)")
            } else {
                complete()
            }
        }
    }
    
    // Fetches all my friends UID for later use in retrieving data
    func fetchAllFriendsUID(complete: @escaping([String]) -> ()) {
        db.collection("users").document(auth.currentUser!.uid).collection("friendsList").getDocuments { (querySnapshot, error) in
            guard querySnapshot?.documents.isEmpty == false else { return }
            var friendList = [String]()
            
            for document in querySnapshot!.documents {
                let uid = document.get("uid") as! String
                friendList.append(uid)
            }
            complete(friendList)
        }
    }
    
    // Fetches my friends name and current highscore
    func fetchFriendsNameAndScore(targetUid: String, complete: @escaping(FetchedUser) -> ()) {
        db.collection("users").document(targetUid).getDocument { (document, error) in
            guard document?.exists == true else { return }
            
            let name = document!.get("nickname") as! String
            let score = document!.get("onlineScore") as! Int
            let friend = FetchedUser(name: name, uid: targetUid, score: score)
            complete(friend)
        }
    }
    
    // Accepts target friend request and adds both users to eachothers friendsList document
    func acceptFriendRequest(targetUid: String, complete: @escaping() -> Void) {
        // Assigns current user uid -> Target users friendslist
        db.collection("users").document(targetUid).collection("friendsList").document(auth.currentUser!.uid).setData(["uid" : auth.currentUser!.uid]) { error in
            if let error = error {
                print("!Error: \(error.localizedDescription)")
            } else {
                
                // Assigns Target uid -> Current users friendslist
                self.db.collection("users").document(self.auth.currentUser!.uid).collection("friendsList").document(targetUid).setData(["uid" : targetUid]) { error in
                    if let error = error {
                        print("!Error: \(error.localizedDescription)")
                    } else {
                        complete()
                    }
                }
            }
        }
    }
    
    func sendFriendRequest(targetUid: String, complete: @escaping() -> Void) {
        let myInfo: [String : Any] = [
            "nickname" : Player.user.name,
            "uid" : auth.currentUser!.uid
        ]
        
        db.collection("users").document(targetUid).collection("friendRequest").document(auth.currentUser!.uid).setData(myInfo) { error in
            if let error = error {
                print("!Error: \(error.localizedDescription)")
            } else {
                complete()
            }
        }
    }
    
    // Returns all your pending friend requests in an array of type: [Fetcheduser]
    func getAllFriendRequests(complete: @escaping([FetchedUser]) -> ()) {
        db.collection("users").document(auth.currentUser!.uid).collection("friendRequest").getDocuments { (querySnapshot, error) in
            guard querySnapshot?.documents.isEmpty == false else { return }
            var userList = [FetchedUser]()
            
            for friendRequest in querySnapshot!.documents {
                let name = friendRequest.get("nickname") as! String
                let uid = friendRequest.get("uid") as! String
                
                let user = FetchedUser.init(name: name, uid: uid, score: 0)
                userList.append(user)
            }
            complete(userList)
        }
    }
    
    // Fetches all users nickname and uid that are registered in database in the form of: [Fetcheduser]
    func getAllUsers(complete: @escaping([FetchedUser]) -> ()) {
        db.collection("users").getDocuments { (querysnapshot, error) in
            if let error = error {
                print("!Error fetching all users \(error.localizedDescription)")
            } else {
                var userList = [FetchedUser]()
                
                for document in querysnapshot!.documents {
                    let name = document.get("nickname") as! String
                    let uid = document.get("uid") as! String
                    
                    let user = FetchedUser.init(name: name, uid: uid, score: 0)
                    userList.append(user)
                }
                complete(userList)
            }
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
    
    func loginUserToFirestore(email: String, password: String, complete: @escaping () -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard (result?.user) != nil else {
                print("Error: \(error?.localizedDescription ?? "Logging in")")
                return
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
