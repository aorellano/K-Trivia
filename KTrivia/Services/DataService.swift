//
//  AppDataService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import UIKit

protocol DataService {
    func getGroups(completion: @escaping ([String]) -> Void)
    func getQuestions(for group: String, and type: String, completion: @escaping ([Trivia]) -> Void)
    func getUsersGameIds(for user: String, completion: @escaping ([Game]) -> Void)
    func updateUsers(score: Int, with id: String)
    func getUsers(completion: @escaping ([SessionUserDetails]) -> Void)
    func createQuestion(with category: String, type: String, question: String, correctAnswer: String, incorrectAnswers: [String], screenshot: UIImage, audio: String)
    func createChoiceQuestion(with category: String, type: String, question: String, correctAnswer: String, incorrectAnswers: [String])
    func getFriends(for user: String, completion: @escaping ([[String:String]]) -> Void)
    func addFriend(to user: [String:String], with friend: [String:String])
}

class DataServiceImpl: ObservableObject, DataService {
    @Published var groups = [String]()
    @Published var questions = [Trivia]()
    @Published var games = [Game]()
    @Published var users = [SessionUserDetails]()
    @Published var friends = [[String:String]]()
    
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
                    
                let triviaQuestion = Trivia(category: category, type: type, question: question, correct_Answer: correctAnswer, incorrect_answers: incorrectAnswers, file: file)
                    
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
                let winnerId = data["winnerId"] as? String ?? ""
                
                if gameIds.contains(id) {
                    let game = Game(id: id, groupName: groupName, player1: player1, player2: player2, player1Score: player1Score, player2Score: player2Score, player1TotalScore: player1TotalScore, player2TotalScore: player2TotalScore, blockPlayerId: blockPlayerId, winnerId:winnerId)
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
            
                return SessionUserDetails(id: id, username: username, profilePic: profilePic, games: [""], totalScore: totalScore, friends: [["":""]])
               
                }
              
            
            completion(
                self.users
            )
        }
    }
    func createQuestion(with category: String, type: String, question: String, correctAnswer: String, incorrectAnswers: [String], screenshot: UIImage, audio: String) {
        
        let uuid = UUID().uuidString
        
        let question = Trivia(category: category, type: type, question: question, correct_Answer: correctAnswer, incorrect_answers: incorrectAnswers, file: "")
        
        storeScreenshot(of: screenshot, with: uuid, question: question)
//
//        do {
//            try FirebaseReference(.questions).document().setData(from: question)
//
//        } catch {
//            print("Error creating online game \(error.localizedDescription)")
//        }
        
//        let gameRef = FirebaseReference(.questions).document(id)
//        gameRef.updateData(["totalScore": FieldValue.increment(totalScore)]) { error in
//                if let err = error {
//                    print(err)
//                    return
//                }
//            }
        
//        if audio == "" {
//            storeScreenshot(of: type, with: screenshot)
//        } else {
//            print("this is audio")
//        }
        
    }
    
    func createChoiceQuestion(with category: String, type: String, question: String, correctAnswer: String, incorrectAnswers: [String]) {
        let uuid = UUID().uuidString
        
        let question = Trivia(category: category, type: type, question: question, correct_Answer: correctAnswer, incorrect_answers: incorrectAnswers, file: "")
        
        storeData(screenshot: "", question: question)
        //storeScreenshot(of: screenshot, with: uuid, question: question)
//
    }
    func storeScreenshot(of image: UIImage, with id: String, question: Trivia){
//        if type == "MV" {
//            print("this is a photo")
//        } else {
//            print("this is a performacne")
//        }
//
        let ref = Storage.storage().reference(withPath: id)
        let imageData = image.jpegData(compressionQuality: 0.5)!
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to storage \(err)")
                    return
            }

            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retreive downloadURL \(err)")
                    return
                }

                let screenshot = url?.absoluteString ?? ""
                self.storeData(screenshot: screenshot, question: question)
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
            }
        }
    }
    
    func storeData(screenshot: String, question: Trivia) {
        let q = Trivia(category: question.category, type: question.type, question: question.question, correct_Answer: question.correct_Answer, incorrect_answers: question.incorrect_answers, file: screenshot)
        print(q)
                do {
                    try FirebaseReference(.questions).document().setData(from: q)
        
                } catch {
                    print("Error creating online game \(error.localizedDescription)")
                }
    }
    
    func getFriends(for user: String, completion: @escaping (([[String:String]]) -> Void)) {
        let docRef = FirebaseReference(.users).document(user)
        docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    print("TRYING")
                    self.friends = data?["friends"] as? [[String:String]] ?? [["":""]]
                    print(self.friends)
                    completion(
                        self.friends
                    )
                } else {
                    print("Document does not exist")
                }
        }
    }
    
    func addFriend(to user: [String:String], with friend: [String:String]) {
        var ref = FirebaseReference(.users).document(user.values.first ?? "")
//        gameRef.updateData(["totalScore": FieldValue.increment(totalScore)]) { error in
//                if let err = error {
//                    print(err)
//                    return
//                }
//            }
        //FieldValue.arrayUnion([gameId])]
        
        //ref.updateData(["friends"])
        
        ref.updateData(["friends": FieldValue.arrayUnion([friend])])
        
        var ref2 = FirebaseReference(.users).document(friend.values.first ?? "")
        ref2.updateData(["friends": FieldValue.arrayUnion([user])])
    
        

                
    }
}
        

