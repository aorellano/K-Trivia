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
    func getQuestions(for group: String, and type: String) async throws -> [Trivia]
    func createQuestion(with category: String, type: String, question: String, correctAnswer: String, incorrectAnswers: [String], screenshot: UIImage, audio: String)
    func createChoiceQuestion(with category: String, type: String, question: String, correctAnswer: String, incorrectAnswers: [String])
}

class DataServiceImpl: ObservableObject, DataService {
    @Published var questions = [Trivia]()
    
    func getQuestions(for group: String, and type: String) async throws -> [Trivia] {
        let snapshot = try await FirebaseReference(.questions).whereField("category", isEqualTo: group).whereField("type", isEqualTo: type).getDocuments()
        
        return snapshot.documents.compactMap { document in
            let data = document.data()
            let category = data["category"] as? String ?? ""
            let type = data["type"] as? String ?? ""
            let question = data["question"] as? String ?? ""
            let correctAnswer = data["correct_answer"] as? String ?? ""
            let incorrectAnswers = data["incorrect_answers"] as? [String] ?? [""]
            let file = data["file"] as? String ?? ""
            
            return Trivia(category: category, type: type, question: question, correct_Answer: correctAnswer, incorrect_answers: incorrectAnswers, file: file)
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
    }
    
    func storeScreenshot(of image: UIImage, with id: String, question: Trivia){
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
        let triviaQuestion = Trivia(category: question.category, type: question.type, question: question.question, correct_Answer: question.correct_Answer, incorrect_answers: question.incorrect_answers, file: screenshot)

        do {
            try FirebaseReference(.questions).document().setData(from: triviaQuestion)

        } catch {
            print("Error creating online game \(error.localizedDescription)")
        }
    }
}
        

