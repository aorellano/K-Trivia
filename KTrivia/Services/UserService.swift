//
//  UserService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/7/22.
//
    
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

import Combine


class UserService {

    @Published var users = [SessionUserDetails]()
    @Published var games = [Game]()
    
    static let shared = UserService()
    
    func getUsers(completion: @escaping ([SessionUserDetails]) -> Void) {
        FirebaseReference(.users).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }

            self.users = documents.map { (queryDocumentSnapshot) -> SessionUserDetails in
                let data = queryDocumentSnapshot.data()
                let id = data["uid"] as? String ?? ""
                print(id)
                let username = data["username"] as? String ?? ""
                print(username)
                let profilePic = data["profilePicUrl"] as? String ?? ""
                print(profilePic)
                let totalScore = data["totalScore"] as? Double ?? 0.0
                print(totalScore)

                return SessionUserDetails(id: id, username: username, profilePic: profilePic, totalScore: totalScore, games: [""], friends: [["":""]])

                }


            completion(
                self.users
            )
        }
    }
    
    func getGames(completion: @escaping([Game]) -> Void) {
        FirebaseReference(.game).getDocuments{ snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let games = documents.compactMap({ try? $0.data(as: Game.self)})
            //self.listenForGameChanges()
            completion(games)
        }
    }
    
//        func listenForGameChanges() {
//            FirebaseReference(.game).addSnapshotListener { [self] documentSnapshot, error in
//
//
//                if error != nil {
//                    print("Error listening to changes \(String(describing: error?.localizedDescription))")
//                }
//
//                if let snapshot = documentSnapshot {
//                    self.games = snapshot.doucuments.compactMap({ try? $0.data(as: Game.self)})
//                }
//            }
//        }

//    func getUsersGameIds(for user: String, completion: @escaping ([Game]) -> Void) {
//        let docRef = FirebaseReference(.users).document(user)
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let data = document.data()
//                let games = data?["games"] as? [String] ?? [""]
//                print("hi \(games)")
//                self.getGameInformation(with: games) { games in
//                    completion(
//                        self.games
//                    )
//                }
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }
    
//    func getUsersGameIds(for user: String) -> AnyPublisher<[Game], IncrementError> {
//        let query = FirebaseReference(.games).whereField("uid", isEqualTo: user)
//        return Publishers.QuerySnapshotPublisher(query: query)
//            .flatMap { snapshot -> AnyPublisher<[Game], IncrementError> in
//                do {
//                    let games = try snapshot.documents
//                }
//            }.eraseToAnyPublisher()
//    }
    
//    func getGameInformation(with gameIds: [String], completion: @escaping ([Game]) -> Void) {
////        if gameIds.count == 1 && gameIds.first == "" {
//            return
////        }
//
//
//        FirebaseReference(.game).addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                return
//            }
//
//
//
//            self.games = documents.map { (queryDocumentSnapshot) -> Game in
//                let data = queryDocumentSnapshot.data()
//                let id = data["id"] as? String ?? ""
//                let player1 = data["player1"] as? [String: String] ?? ["":""]
//                let player2 = data["player2"] as? [String: String] ?? ["":""]
//                let groupName = data["groupName"] as? String ?? ""
//                let player1Score = data["player1Score"] as? String ?? ""
//                let player2Score = data["player2Score"] as? String ?? ""
//                let blockPlayerId = data["blockPlayerId"] as? String ?? ""
//                let player1TotalScore = data["player1TotalScore"] as? String ?? ""
//                let player2TotalScore = data["player2TotalScore"] as? String ?? ""
//                let winnerId = data["winnerId"] as? String ?? ""
//
//                if gameIds.contains(id) {
//                    let game = Game(id: id, groupName: groupName, player1: player1, player2: player2, player1Score: player1Score, player2Score: player2Score, player1TotalScore: player1TotalScore, player2TotalScore: player2TotalScore, blockPlayerId: blockPlayerId, winnerId:winnerId)
//                    return game
//
//                }
//
//                return Game(id: "", groupName: "", player1: ["":""], player2: ["":""], player1Score: "", player2Score: "", player1TotalScore: "", player2TotalScore: "", blockPlayerId: "", winnerId:"")
//            }
//
//            completion(
//                self.games
//            )
//        }
//    }
//
    
}
