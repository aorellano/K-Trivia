//
//  TriviaViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/11/22.
//

import FirebaseFirestore
import SwiftUI
import Combine

class TriviaViewModel: ObservableObject {
    var questions = [Trivia]()
    var dataService: DataService
    var sessionService: SessionService
    var gameService: GameService
    var categoryType: String?
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
    @Published var currentUser: SessionUserDetails?
    @Published var game: Game? {
        didSet {
            checkIfBothPlayersHaveFinished()
        }
    }
    @Published var isPlayerOne = false
    @Published var results: String?
    
    init(groupName: String, sessionService: SessionService, dataService: DataService = DataServiceImpl(), gameService: GameService = GameServiceImpl()) {
        self.dataService = dataService
        self.sessionService = sessionService
        self.gameService = gameService
        //self.getQuestions(for: groupName, and: categoryType ?? "")
        self.retrieveUser()
    }
    
    
    func getQuestions(for group: String, and type: String) {
        dataService.getQuestions(for: group, and: type) {[weak self] questions in
            self?.questions = questions
            self?.question = questions.randomElement()
            self?.answers = self?.question?.answers ?? [Answer(text: "", isCorrect: false)]
            self?.length = questions.count
        }
    }
    
    func setQuestion() {
        answerSelected = false
        progress = CGFloat(Double(index + 1) / Double(5) * 350)

        let currentTriviaQuestion = questions.first
        question = currentTriviaQuestion
        answers = question?.answers ?? [Answer(text: "", isCorrect: false)]
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
    
    func getTheGame() {
        gameService.startGame(with: currentUser!) {[weak self] game in
            self?.game = game
        }
    }
    
    func endGame() {
        print("end of game")
        updatePlayerScore()
        checkIfBothPlayersHaveFinished()
        reachedEnd = true
    }
    
    func updatePlayerScore() {
        if game?.player1["id"] == currentUser?.id {
            gameService.updatePlayer1(score: String(score))
            gameService.listenForGameChanges() {[weak self] game in
                self?.game = game
            }
            isPlayerOne = true
        } else {
            gameService.updatePlayer2(score: String(score))
            gameService.listenForGameChanges() {[weak self] game in
                self?.game = game
            }
        }
    }
    
    func checkIfBothPlayersHaveFinished() {
        print("checking game")
        if gameService.game?.player1Score != "" && gameService.game?.player2Score != "" {
            if isPlayerOne && gameService.game.player1Score > gameService.game.player2Score {
                results = "YOU WON! :)"
                gameService.updateWinner(id:game?.player1["id"] ?? "")
            } else if gameService.game.player1Score == gameService.game.player2Score {
                results = "TIE!"
                
            } else if !isPlayerOne && gameService.game.player1Score < gameService.game.player2Score {
                results = "YOU WON! :)"
                gameService.updateWinner(id: game?.player2["id"] ?? "")
            } else {
                results = "YOU LOST! :("
            }
        }
    }
    

    func retrieveUser() {
        currentUser = sessionService.userDetails
        print("Current User: \(String(describing: currentUser))")
    }
}


