//
//  UsersService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/26/22.
//

import Foundation
import Firebase

protocol UsersService {
    func getUsers(with username: String) async throws -> [SessionUserDetails]
    func getFriends(for user: String) async throws -> [[String:String]]
    func addFriend(to user: SessionUserDetails, with friend: SessionUserDetails)
}

class UsersServiceImpl: ObservableObject, UsersService {
    func getUsers(with username: String) async throws -> [SessionUserDetails] {
        let snapshot = try await FirebaseReference(.users).whereField("username", isEqualTo: username).getDocuments()
        
        return snapshot.documents.compactMap { document in
            let data = document.data()
            let id = data["uid"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let profilePic = data["profilePicUrl"] as? String ?? ""
            let totalScore = data["totalScore"] as? Double ?? 0.0
            return SessionUserDetails(id: id, username: username, profilePic: profilePic, totalScore: totalScore, games: [""], friends: [["":""]])
        }
    }
    
    func getFriends(for user: String) async throws -> [[String : String]] {
        let snapshot = try await FirebaseReference(.users).document(user).getDocument()
        let data = snapshot.data()
        
        return data?["friends"] as? [[String:String]] ?? [["":""]]
    }
    
    func addFriend(to user: SessionUserDetails, with friend: SessionUserDetails) {
        let ref = FirebaseReference(.users).document(user.id)
        
        ref.updateData(["friends": FieldValue.arrayUnion([["id":friend.id, "username":friend.username, "profile_pic":friend.profilePic]])]) { error in
            if let err = error {
                print(err)
                return
            }
        }
        
        let ref2 = FirebaseReference(.users).document(friend.id)
        ref2.updateData(["friends": FieldValue.arrayUnion([["id":user.id, "username":user.username, "profile_pic": user.profilePic]])]) { error in
            if let err = error {
                print(err)
                return
            }
        }
    }
}
