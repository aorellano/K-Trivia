//
//  TriviaService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/12/22.
//

import SwiftUI

protocol TriviaService {
    func setQuestion()
    func goToNextQuestion()
    func selectAnswer(answer: Answer)
    func resetGame()
    func endGame()
    var dataService: DataService{ get }
}


