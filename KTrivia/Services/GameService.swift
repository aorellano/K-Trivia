//
//  GameService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/18/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine
import UserNotifications

class GameService: ObservableObject {
    static let shared = GameService()
    @Published var game: Game!
    
    init() {
        
    }
    
    func createOnlineGame() {
        do {
            try FirebaseReference(.game).document(self.game.id).setData(from: self.game)
        } catch {
            print("Error creating online game: \(error.localizedDescription)")
        }
    }
    
    func createNewGame(with user: SessionUserDetails, and friend: UserInfo, and groupName: String) {
        let userInfo = ["id": user.id, "profile_pic": user.profilePic, "username": user.username]
        let friendInfo = ["id": friend.id, "profile_pic": friend.profile_pic, "username": friend.username]
        print("GROUPNAME \(groupName)")
        self.game = Game(id: UUID().uuidString, groupName: groupName, player1: userInfo, player2: friendInfo, player1Score: "0", player2Score: "0", player1TotalScore: "0", player2TotalScore: "0", blockPlayerId: userInfo["id"] ?? "", winnerId:"")
        self.updateGame(self.game)
        self.updateUser(id: user.id, with: self.game.id)
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func startGameWithFriend(with currentUser: SessionUserDetails, and friend: UserInfo, and groupName: String) {
        print("LETS DO IT")
        let player1Info = ["id": currentUser.id, "profile_pic": currentUser.profilePic, "username": currentUser.username]
        let player2Info = ["id": friend.id, "profile_pic": friend.profile_pic, "username": friend.username]
        print("GROUPNAME \(groupName)")
        self.game = Game(id: UUID().uuidString, groupName: groupName, player1: player1Info, player2: player2Info, player1Score: "0", player2Score: "0", player1TotalScore: "0", player2TotalScore: "0", blockPlayerId: player1Info["id"] ?? "", winnerId:"")
        self.updateGame(self.game)
        self.updateUser(id: currentUser.id, with: self.game.id)
        self.updateUser(id: friend.id, with: self.game.id)
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func startRandomGame(with user: SessionUserDetails,  and groupName: String) {
        let player1 = ["id": user.id, "profile_pic": user.profilePic, "username": user.username]
        
        FirebaseReference(.game)
            .whereField("player2", isEqualTo: ["id":"","profile_pic":"","username":""])
            .whereField("player1", isNotEqualTo: player1)
            .whereField("groupName", isEqualTo: groupName)
            .getDocuments { querySnapshot, error in
            if error != nil {
                print("Error starting game: \(String(describing: error?.localizedDescription))")
                self.createNewGame(with: user, and: groupName)
                return
            }

            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: Game.self)
                self.game.player2 = player1
                self.game.blockPlayerId = player1["id"] ?? ""
                self.updateGame(self.game)
                self.updateUser(id: user.id, with: self.game.id)
                self.listenForGameChanges()
            } else {
                self.createNewGame(with: user, and: groupName)
            }
        }
    }
    func createNewGame(with user: SessionUserDetails, and groupName: String) {
        let userInfo = ["id": user.id, "profile_pic": user.profilePic, "username": user.username]
        print("GROUPNAME \(groupName)")
        self.game = Game(id: UUID().uuidString, groupName: groupName, player1: userInfo, player2: ["id":"", "profile_pic":"", "username":""], player1Score: "0", player2Score: "0", player1TotalScore: "0", player2TotalScore: "0", blockPlayerId: userInfo["id"] ?? "", winnerId:"")
        self.updateGame(self.game)
        self.updateUser(id: user.id, with: self.game.id)
        self.createOnlineGame()
        self.listenForGameChanges()
    }

    func updateGame(_ game: Game) {
        print("... updating game")
        var ctr = 0
        do {
            try FirebaseReference(.game).document(game.id).setData(from: game)
            ctr += 1
            print(ctr)
        } catch {
            print("Error creating online game \(error.localizedDescription)")
        }
    }
    
    func resumeGame(with id: String) {
        print("... resuming game")
        print(id)
        FirebaseReference(.game)
            .whereField("id", isEqualTo: id).getDocuments { querySnapshot, error in
            if error != nil {
                print("Error starting game: \(String(describing: error?.localizedDescription))")
         
                return
            }

            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: Game.self)
                print(self.game)
//                self.game.player2 = player1
//                self.game.blockPlayerId = player1["id"] ?? ""
                self.updateGame(self.game)
//                self.updateUser(id: user.id, with: self.game.id)
                self.listenForGameChanges()
            }
        }

    }
    
    
    
    func updateUser(id: String, with gameId: String) {
        let gameRef = FirebaseReference(.users).document(id)
        gameRef.updateData(["games": FieldValue.arrayUnion([gameId])]) { error in
                if let err = error {
                    print(err)
                    return
                }
            }
        print("Games updated!")
    }

    func listenForGameChanges() {
        FirebaseReference(.game).document(self.game.id).addSnapshotListener { [self] documentSnapshot, error in
            print("changes recieved from firebase \(game.player1Score)")

            if error != nil {
                print("Error listening to changes \(String(describing: error?.localizedDescription))")
            }

            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: Game.self)
            }
        }
    }
    
    func quitGame() {
        FirebaseReference(.game).document(self.game.id).delete()
    }
}



