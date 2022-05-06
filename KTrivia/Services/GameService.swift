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

    func startGame(with user: SessionUserDetails, and groupName: String) {
        let player1 = ["id": user.id, "profile_pic": user.profilePic, "username": user.username]
        
        FirebaseReference(.game)
            .whereField("player2", isEqualTo: ["id":"","profile_pic":"","username":""])
            .whereField("player1", isNotEqualTo: player1)
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
        self.game = Game(id: UUID().uuidString, groupName: groupName, player1: userInfo, player2: ["id":"", "profile_pic":"", "username":""], player1Score: "", player2Score: "", player1TotalScore: "", player2TotalScore: "", blockPlayerId: userInfo["id"] ?? "", winnerId:"")
        self.updateGame(self.game)
        self.updateUser(id: user.id, with: self.game.id)
        self.createOnlineGame()
        self.listenForGameChanges()
    }

    func updateGame(_ game: Game) {
        print("... updating game")
        do {
            try FirebaseReference(.game).document(game.id).setData(from: game)
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

//    func updatePlayer1(score: String) {
//        FirebaseReference(.game).document(self.game.id).setData([
//            "id": self.game.id,
//            "player1": self.game.player1,
//            "player2": self.game.player2,
//            "player1Score": score,
//            "player2Score": self.game.player2Score,
//            "player1TotalScore": self.game.player1TotalScore,
//            "player2TotalScore": self.game.player2TotalScore,
//            "blockPlayerId": self.game.blockPlayerId,
//            "winnerId": self.game.winnerId
//        ])
//    }
//
//    func updatePlayer2(score: String) {
//        //\self.listenForGameChanges()
//        FirebaseReference(.game).document(self.game.id).setData([
//            "id": self.game.id,
//            "player1": self.game.player1,
//            "player2": self.game.player2,
//            "player1Score": self.game.player1Score,
//            "player2Score": score,
//            "player1TotalScore": self.game.player1TotalScore,
//            "player2TotalScore": self.game.player2TotalScore,
//            "blockedPlayerId": self.game.blockPlayerId,
//            "winnerId": self.game.winnerId
//        ])
//    }
//
//    func updatePlayer1Total(score: String) {
//        FirebaseReference(.game).document(self.game.id).setData([
//            "id": self.game.id,
//            "player1": self.game.player1,
//            "player2": self.game.player2,
//            "player1Score": self.game.player1Score,
//            "player2Score": self.game.player2Score,
//            "player1TotalScore": score,
//            "player2TotalScore": self.game.player2TotalScore,
//            "blockedPlayerId": self.game.blockPlayerId,
//            "winnerId": self.game.winnerId
//        ])
//    }
//
//    func updatePlayer2Total(score: String) {
//        FirebaseReference(.game).document(self.game.id).setData([
//            "id": self.game.id,
//            "player1": self.game.player1,
//            "player2": self.game.player2,
//            "player1Score": self.game.player1Score,
//            "player2Score": self.game.player2Score,
//            "player1TotalScore": self.game.player1TotalScore,
//            "player2TotalScore": score,
//            "blockedPlayerId": self.game.blockPlayerId,
//            "winnerId": self.game.winnerId
//        ])
//    }
//
//    func updateBlockedPlayer(id: String) {
//        FirebaseReference(.game).document(self.game.id).setData([
//            "id": self.game.id,
//            "player1": self.game.player1,
//            "player2": self.game.player2,
//            "player1Score": self.game.player1Score,
//            "player2Score": self.game.player2Score,
//            "player1TotalScore": self.game.player1TotalScore,
//            "player2TotalScore": id,
//            "winnerId": self.game.winnerId
//        ])
//    }
//
//    func updateWinner(id: String) {
//        FirebaseReference(.game).document(self.game.id).setData([
//            "id": self.game.id,
//            "player1": self.game.player1,
//            "player2": self.game.player2,
//            "player1Score": self.game.player1Score,
//            "player2Score": self.game.player2Score,
//            "player1TotalScore": self.game.player1TotalScore,
//            "player2TotalScore": self.game.player2TotalScore,
//            "blockedPlayerId": self.game.blockPlayerId,
//            "winnerId": id
//        ])
//    }
}



