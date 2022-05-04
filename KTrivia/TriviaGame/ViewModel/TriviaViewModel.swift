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
    var categoryType: String?
    private var cancellables: Set<AnyCancellable> = []
    @Published var gameNotification = GameNotfication.waitingForPlayer
    @Published private(set) var reachedEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var question: Trivia?
    @Published private(set) var answers: [Answer] = []
    @Published private(set) var score = 0
    @Published private(set) var totalScore = 0
    @State var isActive = true
    @Published var currentUser: SessionUserDetails?
    @Published var game: Game? {
        didSet {
            //checkIfGameIsOver
            if game == nil {
                updateGameNotificationsFor(.finished)
            } else if game?.player2["id"] == "" {
                updateGameNotificationsFor(.waitingForPlayer)
            } else if game?.blockPlayerId == currentUser!.id {
                updateGameNotificationsFor(.opponentsTurn)
            } else {
                updateGameNotificationsFor(.yourTurn)
            }
        }
    }
    @Published var isPlayerOne = false
    @Published var results: String?

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
   
    
    init(groupName: String, sessionService: SessionService, dataService: DataService = DataServiceImpl()) {
        self.dataService = dataService
        self.sessionService = sessionService
        self.retrieveUser()
    }
    
    func updateGameNotificationsFor(_ state: GameState) {
        switch state {
        case .waitingForPlayer:
            gameNotification = GameNotfication.waitingForPlayer
        case .finished:
            gameNotification = GameNotfication.gameHasFinished
        case .opponentsTurn:
            gameNotification = GameNotfication.opponentsTurn
        case .yourTurn:
            gameNotification = GameNotfication.yourTurn
        }
    }
    
    func getQuestions(for group: String, and type: String) {
        dataService.getQuestions(for: group, and: type) {[weak self] questions in
            self?.questions = questions
            self?.question = questions.randomElement()
            self?.answers = self?.question?.answers ?? [Answer(text: "", isCorrect: false)]
        }
    }
    
    func getTheGame() {
        guard let currentUser = currentUser else {
            return
        }
        GameService.shared.startGame(with: currentUser)
        GameService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
        
    }
    
    func setQuestion() {
        answerSelected = false
        let currentTriviaQuestion = questions.randomElement()
        question = currentTriviaQuestion
        answers = question?.answers ?? [Answer(text: "", isCorrect: false)]
    }
    
    func selectAnswer(answer: Answer) {
        answerSelected = true
        checkIfUserIsPlayerOne()
        updatePlayersScore(answer: answer)
        GameService.shared.updateGame(game!)
    }
    
    func updatePlayersScore(answer: Answer) {
        if score == 3 {
            updateTotalScore()
        }
        if answer.isCorrect && isPlayerOne {
            score += 1
            game?.player1Score = String(score)
        } else if answer.isCorrect && !isPlayerOne {
            score += 1
            game?.player2Score = String(score)
        } else if !answer.isCorrect && isPlayerOne {
            score = 0
            game?.player1Score = String(score)
            game?.blockPlayerId = currentUser?.id ?? ""
        } else {
            score = 0
            game?.player2Score = String(score)
            game?.blockPlayerId = currentUser?.id ?? ""
        }
    }
    
    func updateTotalScore() {
        totalScore += 1
        score = 0
        
        if totalScore == 3 {
            print("You have won the game")
        }
        
        if isPlayerOne {
            game?.player1TotalScore = String(totalScore)
            game?.player1Score = String(score)
        } else {
            game?.player2TotalScore = String(totalScore)
            game?.player2Score = String(score)
        }
    }
    
    func resetGame() {
        score = 0
    }

    func endGame() {
//        print("end of game")
//        updatePlayerScore(with: 0)
//        checkIfBothPlayersHaveFinished()
//        reachedEnd = true
    }
    
    
    func checkForGameStatus() -> Bool {
        return game != nil ? game?.blockPlayerId == currentUser?.id : false
           
    }
    
//    func updatePlayerScore(with totalScore: Int) {
//        
//        if game?.player1["id"] == currentUser?.id {
//            gameService.updatePlayer1(score: String(score))
//            if totalScore > 0 {
//                gameService.updatePlayer1Total(score: String(totalScore))
//
//            }
//            gameService.listenForGameChanges() {[weak self] game in
//                self?.game = game
//            }
//            isPlayerOne = true
//            
//        } else {
//            gameService.updatePlayer2(score: String(score))
//            if totalScore > 0 {
//                gameService.updatePlayer2Total(score: String(totalScore))
//
//            }
//            gameService.listenForGameChanges() {[weak self] game in
//                self?.game = game
//            }
//        }
//    }
//    
    func checkIfBothPlayersHaveFinished() {
        print("checking game")
//        if gameService.game?.player1Score != "" && gameService.game?.player2Score != "" {
//            if isPlayerOne && gameService.game.player1Score > gameService.game.player2Score {
//                results = "YOU WON! :)"
//                gameService.updateWinner(id:game?.player1["id"] ?? "")
//            } else if gameService.game.player1Score == gameService.game.player2Score {
//                results = "TIE!"
//
//            } else if !isPlayerOne && gameService.game.player1Score < gameService.game.player2Score {
//                results = "YOU WON! :)"
//                gameService.updateWinner(id: game?.player2["id"] ?? "")
//            } else {
//                results = "YOU LOST! :("
//            }
//        }
    }
    
    func retrieveUser() {
        currentUser = sessionService.userDetails
        print("Current User: \(String(describing: currentUser))")
    }
    
    func checkIfUserIsPlayerOne() {
        if game?.player1["id"] == currentUser?.id {
            isPlayerOne = true
        } else {
            isPlayerOne = false
        }
    }
}


