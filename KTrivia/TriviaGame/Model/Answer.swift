//
//  Answer.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/12/22.
//

import Foundation

struct Answer: Identifiable {
    var id = UUID()
    var text: AttributedString
    var isCorrect: Bool
}
