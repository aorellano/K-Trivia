//
//  TriviaViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/11/22.
//

import FirebaseFirestore
import SwiftUI

class TriviaViewModel: ObservableObject {
    var questions = [Trivia]()
    var dataService: DataService
    var triviaManager: TriviaService
    @Published private(set) var length = 0
    @Published private(set) var index = 0
    @Published private(set) var reachedEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var question: Trivia?
    @Published private(set) var answers: [Answer] = []
    @Published private(set) var progress: CGFloat = 0.00
    @Published private(set) var score = 0
    @State var isActive = true

    
    init(groupName: String, dataService: FirebaseService = FirebaseService(), triviaManager: ClassicGameManager = ClassicGameManager()) {
        self.dataService = dataService
        self.triviaManager = triviaManager
        getQuestions(for: groupName)
    }
    
  
    
    func getQuestions(for group: String) {
        dataService.getQuestions(for: group) {[weak self] questions in
            self?.questions = questions
            
            self?.question = questions.randomElement()
            
            self?.answers = self?.question?.answers ?? [Answer(text: "", isCorrect: false)]
            self?.length = questions.count
      
        }
    }
    
    func resetGame() {
        index = 0
        score = 0
        print(questions)
    }
    func goToNextQuestion() {
        print(index)
        print(length)
        print(questions)

//        if index + 1 < 5 {
//            setQuestion()
//            index += 1
//        } else{
//            reachedEnd = true
//        }
        if index + 1 < 5 {
            index += 1
            setQuestion()
        }
        
        if index == 4 {
            reachedEnd = true
            print("reached the end of the game")
            
        }

    }
    
    func setQuestion() {
        answerSelected = false
        progress = CGFloat(Double(index + 1) / Double(5) * 350)
    
        if index < length {
            print(length)
            print("index: \(index)")
            let currentTriviaQuestion = questions[index]
            question = currentTriviaQuestion
            answers = question?.answers ?? [Answer(text: "", isCorrect: false)]
        }
    }

    func selectAnswer(answer: Answer) {
        answerSelected = true
        if answer.isCorrect {
            score += 1
        }
    }
}


