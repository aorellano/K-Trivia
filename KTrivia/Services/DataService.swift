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

class DataServiceImpl: DataService {
    @Published var groups = [String]()
    @Published var questions = [Trivia]()

    func getGroups(completion: @escaping ([String]) -> Void) {
        print("getting groups")
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
    
    func getQuestions(for group: String, completion: @escaping ([Trivia]) -> Void) {
        FirebaseReference(.questions).whereField("category", isEqualTo: group).addSnapshotListener { (querySnapshot, error) in
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
            }.shuffled().enumerated().compactMap{ $0.offset < 5 ? $0.element : nil }
            
            completion(
                self.questions
            )
        }
    }
}
