//
//  Question.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Trivia: Identifiable, Codable {
    var id: String = UUID().uuidString
    var category: String
    var type: String
    var question: String
    var correct_Answer: String
    var incorrect_answers: [String]
    var file: String
    
    var formattedQuestion: AttributedString {
        do {
            return try AttributedString(markdown: question)
        } catch {
            print("Error setting formattedQuestion: \(error)")
            return ""
        }
    }
    
    var answers: [Answer] {
        do {
            let correctAnswer = [Answer(text: try AttributedString(markdown: correct_Answer), isCorrect: true)]
            let incorrects = try incorrect_answers.map { answer in
                Answer(text: try AttributedString(markdown: answer), isCorrect: false)
            }
            let allAnswers = correctAnswer + incorrects
            return allAnswers.shuffled()
                
        } catch {
            print("Error setting answers: \(error)")
            return []
        }
    }
}
