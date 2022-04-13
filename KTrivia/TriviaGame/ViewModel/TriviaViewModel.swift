//
//  TriviaViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/11/22.
//

import FirebaseFirestore
import SwiftUI
import Combine

class TriviaViewModel: ObservableObject, TriviaService {
    //@AppStorage("user") private var userData: Data?
    
    var questions = [Trivia]()
    var dataService: DataService
    var sessionService: SessionService
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published private(set) var length = 0
    @Published private(set) var index = 0
    @Published private(set) var reachedEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var question: Trivia?
    @Published private(set) var answers: [Answer] = []
    @Published private(set) var progress: CGFloat = 0.00
    @Published private(set) var score = 0
    @Published var timeRemaining = 30
    @State var isActive = true
    @Published var currentUser: String?
    @Published var game: Game?

    init(groupName: String, session: SessionService, dataService: FirebaseService = FirebaseService()) {
        self.dataService = dataService
        self.sessionService = session
        self.getQuestions(for: groupName)
        self.retrieveUser()
        self.getTheGame()
//
//        if currentUser == nil {
//            saveUser()
//        }
    }
    
    func getTheGame() {
        dataService.startGame(with: currentUser!) {[weak self] game in
            self?.game = game
        }
    }
    
    func getQuestions(for group: String) {
        dataService.getQuestions(for: group) {[weak self] questions in
            self?.questions = questions
            self?.question = questions.randomElement()
            self?.answers = self?.question?.answers ?? [Answer(text: "", isCorrect: false)]
            self?.length = questions.count
        }
    }
    
    func setQuestion() {
        answerSelected = false
        progress = CGFloat(Double(index + 1) / Double(5) * 350)

        if index < length {
            let currentTriviaQuestion = questions[index]
            question = currentTriviaQuestion
            answers = question?.answers ?? [Answer(text: "", isCorrect: false)]
        }
    }
    
    func goToNextQuestion() {
        if index + 1 < 5 {
            index += 1
            setQuestion()
        }
        if index == 4 {
            reachedEnd = true
        }
    }
    
    func selectAnswer(answer: Answer) {
        answerSelected = true
        if answer.isCorrect {
            score += 1
        }
    }
    
    func resetGame() {
        index = 0
        score = 0
    }
    
    func endGame() {
        reachedEnd = true
    }
    
    //MARK - User object
    
//    func saveUser() {
//        currentUser = User()
//        do {
//            print("encoding user object")
//            let data = try JSONEncoder().encode(currentUser)
//            userData = data
//        } catch {
//            print("couldnt save user object")
//        }
//    }
    
    func retrieveUser() {
        currentUser = sessionService.userDetails?.id ?? ""
        print(currentUser)
    }
}


