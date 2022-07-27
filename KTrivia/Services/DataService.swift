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
    func updateUsers(score: Int, with id: String)
    func createQuestion(with category: String, type: String, question: String, correctAnswer: String, incorrectAnswers: [String], screenshot: UIImage, audio: String)
    func createChoiceQuestion(with category: String, type: String, question: String, correctAnswer: String, incorrectAnswers: [String])
    func getFriends(for user: String, completion: @escaping ([[String:String]]) -> Void)
    func addFriend(to user: SessionUserDetails, with friend: SessionUserDetails)
    func getUsers(with username: String, completion: @escaping ([SessionUserDetails]) -> Void)
}

class DataServiceImpl: ObservableObject, DataService {
    @Published var groups = [String]()
    @Published var questions = [Trivia]()
    @Published var games = [Game]()
    @Published var friends = [[String:String]]()
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
                    
                let triviaQuestion = Trivia(category: category, type: type, question: question, correct_Answer: correctAnswer, incorrect_answers: incorrectAnswers, file: file)
                    
                return triviaQuestion
            }
            
            completion(
                self.questions
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
    
    func getUsers(with username: String, completion: @escaping ([SessionUserDetails]) -> Void) {
        FirebaseReference(.users).whereField("username", isEqualTo: username).addSnapshotListener { (querySnapshot, error) in
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
                    print(data)
                    self.friends = data?["friends"] as? [[String: String]] ?? [["":""]]
                    
                   
//                    self.friends = SessionUserDetails(id: people["id"], username: people["id"], profilePic: people["profilePic"], totalScore: people["totalScore"], games: nil, friends: nil)
                    print("HELLO\(self.friends)")
                    completion(
                        self.friends
                    )
                } else {
                    print("Document does not exist")
                }
        }
    }
    
    
//    func resumeGame(with id: String) {
//        print("... resuming game")
//        print(id)
//        FirebaseReference(.game)
//            .whereField("id", isEqualTo: id).getDocuments { querySnapshot, error in
//            if error != nil {
//                print("Error starting game: \(String(describing: error?.localizedDescription))")
//
//                return
//            }
//
//            if let gameData = querySnapshot?.documents.first {
//                self.game = try? gameData.data(as: Game.self)
//                print(self.game)
////                self.game.player2 = player1
////                self.game.blockPlayerId = player1["id"] ?? ""
//                self.updateGame(self.game)
////                self.updateUser(id: user.id, with: self.game.id)
//                self.listenForGameChanges(self.game)
//            }
//        }
//
//    }
    
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
        

