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
            checkIfGameIsOver()
        }
    }
    @Published var player2: [String: String]?
    @Published var player1: [String: String]?
    @Published var player1Score: Int?
    @Published var player2Score: Int?
    @Published var isPlayerOne = false
    @Published var results: String?
    
    init(groupName: String, session: SessionService, dataService: DataService = DataServiceImpl(), gameService: GameService = GameServiceImpl()) {
        self.dataService = dataService
        self.sessionService = session
        self.gameService = gameService
        self.getQuestions(for: groupName)
        self.retrieveUser()
        
    }
    
    func getTheGame() {
        gameService.startGame(with: currentUser!) {[weak self] game in
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
        gameService.listenForGameChanges()
        checkIfUserHasAlreadyPlayed()
        updatePlayerScore()
        checkIfGameIsOver()
        reachedEnd = true
    }
    
    func updatePlayerScore() {
        if game?.player1["id"] == currentUser?.id {
            gameService.updatePlayer1Score(String(score))
            player1Score = score
            isPlayerOne = true
        } else {
            gameService.updatePlayer2Score(String(score))
            player2Score = score
        }
        
    }
    
    func checkIfUserHasAlreadyPlayed() {
        if game?.player1Score != "" {
            player1Score = Int(game!.player1Score)
            
        } else if game?.player2Score != "" {
            player2Score = Int(game!.player2Score)
            
        }
    }
    
    func checkIfGameIsOver() {
        print("checking game")
        gameService.listenForGameChanges()
        
//        
//        if game?.player1Score != "" && game?.player2Score != "" {
//            if Int(game!.player1Score)! > Int(game!.player2Score)! {
//                gameService.game.player1["isWinner"] = "true"
//              
//            } else {
//                gameService.game.player2["isWinner"] = "true"
//            }
//            gameService.updateGame(game!)
//        }
        
  
        
        

//        if isPlayerOne ?? true {
//            yourScore = gameService.game?.player1Score
//            opponentScore = gameService.game?.player2Score
//        } else {
//            yourScore = gameService.game?.player2Score
//            opponentScore = gameService.game?.player1Score
//        }
//
        if gameService.game?.player1Score != "" && gameService.game?.player2Score != "" {
            if isPlayerOne && gameService.game.player1Score > gameService.game.player2Score {
                results = "YOU WON! :)"
            } else if gameService.game.player1Score == gameService.game.player2Score {
                results = "TIE!"
            } else if !isPlayerOne && gameService.game.player1Score < gameService.game.player2Score {
                results = "YOU WON! :)"
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


