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
    func getQuestions(for group: String, completion: @escaping ([Trivia]) -> Void)
}

class FirebaseService: DataService {
    private let db = Firestore.firestore()
    @Published var groups = [String]()
    @Published var questions = [Trivia]()
    
    func getGroups(completion: @escaping ([String]) -> Void) {
        db
            .collection("questions")
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.groups = documents.map { (queryDocumentSnapshot) -> String in
                let data = queryDocumentSnapshot.data()
                let category = data["category"] as? String ?? ""
                return category
            }.removeDuplicates()
            
            completion(
                self.groups
            )
        }
    }
    
    func getQuestions(for group: String, completion: @escaping ([Trivia]) -> Void) {
        
        db
            .collection("questions").whereField("category", isEqualTo: group)
            .addSnapshotListener { (querySnapshot, error) in
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
                
                let triviaQuestion = Trivia(category: category, type: type, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
                
                return triviaQuestion
            }
            
            completion(
                self.questions
            )
        }
    }
}
