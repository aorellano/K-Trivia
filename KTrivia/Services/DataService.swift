//
//  AppDataService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol DataService {
    func getGroups(completion: @escaping ([String]) -> Void)
    func getQuestions(for group: String, and type: String, completion: @escaping ([Trivia]) -> Void)
    func getUsersGameIds(for user: String, completion: @escaping ([Game]) -> Void)
    func updateUsers(score: Int, with id: String)
    func getUsers(completion: @escaping ([SessionUserDetails]) -> Void)
}

class DataServiceImpl: ObservableObject, DataService {
    @Published var groups = [String]()
    @Published var questions = [Trivia]()
    @Published var games = [Game]()
    @Published var users = [SessionUserDetails]()
    
    func getGroups(completion: @escaping ([String]) -> Void) {
        FirebaseReference(.questions).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.groups = documents.map { (queryDocumentSnapshot) -> String in
                let data = queryDocumentSnapshot.data()
                let category = data["category"] as? String ?? ""
                return category
            }.removeDuplicates().filter({$0 != ""})
            completion(
                self.groups
            )
        }
    }
    
    func getQuestions(for group: String, and type: String, completion: @escaping ([Trivia]) -> Void) {
        FirebaseReference(.questions).whereField("category", isEqualTo: group).whereField("type", isEqualTo: type).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.questions = documents.map { (queryDocumentSnapshot) -> Trivia in
                let data = queryDocumentSnapshot.data()
                let category = data["category"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let question = data["question"] as? String ?? ""
                let correctAnswer = data["correct_answer"] as? String ?? ""
                let incorrectAnswers = data["incorrect_answers"] as? [String] ?? [""]
                let file = data["file"] as? String ?? ""
                    
                let triviaQuestion = Trivia(category: category, type: type, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers, file: file)
                    
                return triviaQuestion
            }
            
            completion(
                self.questions
            )
        }
    }
    
    func getUsersGameIds(for user: String, completion: @escaping ([Game]) -> Void) {
        
        let docRef = FirebaseReference(.users).document(user)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let games = data?["games"] as? [String] ?? [""]
                print("hi \(games)")
                self.getGameInformation(with: games) { games in
                    completion(
                        self.games
                    )
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getGameInformation(with gameIds: [String], completion: @escaping ([Game]) -> Void) {
        if gameIds.count == 1 && gameIds.first == "" {
            return
        }
        FirebaseReference(.game).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.games = documents.map { (queryDocumentSnapshot) -> Game in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let player1 = data["player1"] as? [String: String] ?? ["":""]
                let player2 = data["player2"] as? [String: String] ?? ["":""]
                let groupName = data["groupName"] as? String ?? ""
                let player1Score = data["player1Score"] as? String ?? ""
                let player2Score = data["player2Score"] as? String ?? ""
                let blockPlayerId = data["blockPlayerId"] as? String ?? ""
                let player1TotalScore = data["player1TotalScore"] as? String ?? ""
                let player2TotalScore = data["player2TotalScore"] as? String ?? ""
                
                if gameIds.contains(id) {
                    let game = Game(id: id, groupName: groupName, player1: player1, player2: player2, player1Score: player1Score, player2Score: player2Score, player1TotalScore: player1TotalScore, player2TotalScore: player2TotalScore, blockPlayerId: blockPlayerId, winnerId:"")
                    return game
            
                }
                
                return Game(id: "", groupName: "", player1: ["":""], player2: ["":""], player1Score: "", player2Score: "", player1TotalScore: "", player2TotalScore: "", blockPlayerId: "", winnerId:"")
            }
            
            completion(
                self.games
            )
        }
    }
    
    
    func updateUsers(score: Int, with id: String) {
        let totalScore = Double(score)
        let gameRef = FirebaseReference(.users).document(id)
        gameRef.updateData(["totalScore": FieldValue.increment(totalScore)]) { error in
                if let err = error {
                    print(err)
                    return
                }
            }
        print("User updated!")
    }
    
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
                return SessionUserDetails(id: id, username: username, profilePic: profilePic, games: [""], totalScore: totalScore)
               
                }
              
            
            completion(
                self.users
            )
        }
    }
}
        

