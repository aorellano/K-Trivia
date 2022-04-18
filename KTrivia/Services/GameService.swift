//
//  GameService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/18/22.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol GameService {
    func createNewGame(with User: SessionUserDetails)
    func startGame(with user: SessionUserDetails, completion: @escaping ((Game) -> Void))
    func createOnlineGame()
    func updateGame(_ game: Game)
    func listenForGameChanges()
    func quitTheGame()
    var game: Game! { get set }
}

class GameServiceImpl: GameService {
    @Published var game: Game!

    func createOnlineGame() {
        do {
            try FirebaseReference(.game).document(self.game.id).setData(from: self.game)
        } catch {
            print("Error creating online game: \(error.localizedDescription)")
        }
    }
    
    func startGame(with user: SessionUserDetails, completion: @escaping ((Game) -> Void)) {
        let player1 = ["id": user.id, "profile_pic": user.profilePic, "username": user.username]
        
        FirebaseReference(.game)
            .whereField("player2", isEqualTo: ["id":"","profile_pic":"","username":""])
            .whereField("player1", isNotEqualTo: player1)
            .getDocuments { querySnapshot, error in
            if error != nil {
                print("Error starting game: \(String(describing: error?.localizedDescription))")
                self.createNewGame(with: user)
                return
            }

            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: Game.self)
                self.game.player2 = player1
                self.updateGame(self.game)
                self.listenForGameChanges()
            } else {
                self.createNewGame(with: user)
            }
            completion(
                self.game
            )
        }
    }
    
    func createNewGame(with user: SessionUserDetails) {
        let userInfo = ["id": user.id, "profile_pic": user.profilePic, "username": user.username]
        print("creating game for \(user.username)")
        self.game = Game(id: UUID().uuidString, player1: userInfo, player2: ["id":"", "profile_pic":"", "username":""], player1Score: "", player2Score: "", winnerPlayerId: "")
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
    
    func listenForGameChanges() {
        FirebaseReference(.game).document(self.game.id).addSnapshotListener { [self] documentSnapshot, error in
            print("changes recieved from firebase")

            if error != nil {
                print("Error listening to changes \(String(describing: error?.localizedDescription))")
            }
            
            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: Game.self)
            }
        }
    }
    
    func quitTheGame() {
        //
    }
    
//    func updatePlayer1Score(_ score: String) {
//        do {
//            try db.collection("game").document(self.game.id).setData([
//                "id": self.game.id,
//                "player1Id": self.game.player1Id,
//                "player2Id": self.game.player2Id,
//                "player1Score": score,
//                "player2Score": self.game.player2Score,
//                "winnerPlayerId": self.game.winnerPlayerId
//
//            ])
//
//
//
//        }
//
//
//
//
//    }
//
//    func updatePlayer2Score(_ score: String) {
//        do {
//            try db.collection("game").document(self.game.id).setData([
//                "id": self.game.id,
//                "player1Id": self.game.player1Id,
//                "player2Id": self.game.player2Id,
//                "player1Score": self.game.player1Score,
//                "player2Score": score,
//                "winnerPlayerId": self.game.winnerPlayerId
//            ])
//
//
//
//        }
//    }
    
//    func findPlayer1Information(_ uid: String, completion: @escaping ((User) -> Void)) {
////        if let gameData = querySnapshot?.documents.first {
////            self.game = try? gameData.data(as: Game.self)
////            self.game.player2Id = userId
////            self.updateGame(self.game)
////            self.listenForGameChanges()
////        } else {
////            self.createNewGame(with: userId)
////        }
////
////            completion(
////                self.game
////            )
//        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { querySnapshot, err in
//            if let user = querySnapshot?.documents.first {
//                print("user has been found: \(user)")
//                self.player1 = try? user.data(as: User.self)
//            } else {
//                print("user not found")
//            }
//
//            completion(
//                self.player1
//            )
//        }
//    }
//    func findPlayer2Information(_ uid: String, completion: @escaping ((User) -> Void)) {
////        if let gameData = querySnapshot?.documents.first {
////            self.game = try? gameData.data(as: Game.self)
////            self.game.player2Id = userId
////            self.updateGame(self.game)
////            self.listenForGameChanges()
////        } else {
////            self.createNewGame(with: userId)
////        }
////
////            completion(
////                self.game
////            )
//        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { querySnapshot, err in
//            if let user = querySnapshot?.documents.first {
//                print("user has been found: \(user)")
//                self.player2 = try? user.data(as: User.self)
//            } else {
//                print("user not found")
//            }
//
//            completion(
//                self.player2
//            )
//        }
//    }

}
