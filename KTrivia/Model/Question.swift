//
//  Question.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Question: Identifiable {
    var id: String = UUID().uuidString
    var category: String
    var type: String
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
}
