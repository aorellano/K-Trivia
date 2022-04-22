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
    func listenForGameChanges(completion: @escaping ((Game) -> Void))
    func updatePlayer1(score: String)
    func updatePlayer2(score: String)
    func updatePlayer1Total(score: String)
    func updatePlayer2Total(score: String)
    func updateWinner(id: String)
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
                self.listenForGameChanges() {[weak self] game in
                    print("game started")
                }
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
        self.game = Game(id: UUID().uuidString, player1: userInfo, player2: ["id":"", "profile_pic":"", "username":""], player1Score: "", player2Score: "", player1TotalScore: "", player2TotalScore: "", winnerId:"")
        self.createOnlineGame()

    }
    
    func updateGame(_ game: Game) {
        print("... updating game")
        do {
            try FirebaseReference(.game).document(game.id).setData(from: game)
        } catch {
            print("Error creating online game \(error.localizedDescription)")
        }
    }
    
    func listenForGameChanges(completion: @escaping ((Game) -> Void)) {
        FirebaseReference(.game).document(self.game.id).addSnapshotListener { [self] documentSnapshot, error in
            print("changes recieved from firebase \(game.player1Score)")
       
            if error != nil {
                print("Error listening to changes \(String(describing: error?.localizedDescription))")
            }
            
            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: Game.self)
            }
            
            completion(
                self.game
            )
        }
    }
    
    func updatePlayer1(score: String) {
        FirebaseReference(.game).document(self.game.id).setData([
            "id": self.game.id,
            "player1": self.game.player1,
            "player2": self.game.player2,
            "player1Score": score,
            "player2Score": self.game.player2Score,
            "player1TotalScore": self.game.player1TotalScore,
            "player2TotalScore": self.game.player2TotalScore,
            "winnerId": self.game.winnerId
        ])
    }
    
    func updatePlayer2(score: String) {
        //\self.listenForGameChanges()
        FirebaseReference(.game).document(self.game.id).setData([
            "id": self.game.id,
            "player1": self.game.player1,
            "player2": self.game.player2,
            "player1Score": self.game.player1Score,
            "player2Score": score,
            "player1TotalScore": self.game.player1TotalScore,
            "player2TotalScore": self.game.player2TotalScore,
            "winnerId": self.game.winnerId
        ])
    }
    
    func updatePlayer1Total(score: String) {
        FirebaseReference(.game).document(self.game.id).setData([
            "id": self.game.id,
            "player1": self.game.player1,
            "player2": self.game.player2,
            "player1Score": self.game.player1Score,
            "player2Score": self.game.player2Score,
            "player1TotalScore": score,
            "player2TotalScore": self.game.player2TotalScore,
            "winnerId": self.game.winnerId
        ])
    }
    
    func updatePlayer2Total(score: String) {
        //\self.listenForGameChanges()
        FirebaseReference(.game).document(self.game.id).setData([
            "id": self.game.id,
            "player1": self.game.player1,
            "player2": self.game.player2,
            "player1Score": self.game.player1Score,
            "player2Score": self.game.player2Score,
            "player1TotalScore": self.game.player1TotalScore,
            "player2TotalScore": score,
            "winnerId": self.game.winnerId
        ])
    }
    
    func updateWinner(id: String) {
        //\self.listenForGameChanges()
        FirebaseReference(.game).document(self.game.id).setData([
            "id": self.game.id,
            "player1": self.game.player1,
            "player2": self.game.player2,
            "player1Score": self.game.player1Score,
            "player2Score": self.game.player2Score,
            "player1TotalScore": self.game.player1TotalScore,
            "player2TotalScore": self.game.player2TotalScore,
            "winnerId": id
        ])
    }
    
//    func updateWinner(with id: String) {
//        self.listenForGameChanges()
//        FirebaseReference(.game).document(self.game.id).setData([
//            "id": self.game.id,
//            "player1": self.game.player1,
//            "player2": self.game.player2,
//            "player1Score": self.game.player1Score,
//            "player2Score": self.game.player2Score,
//        ])
//    }
    func quitTheGame() {
        //
    }
    
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
