//
//  TriviaViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/11/22.
//

import FirebaseFirestore
import SwiftUI
import Combine
import UserNotifications

class TriviaViewModel: ObservableObject {
    var questions = [Trivia]()
    var dataService: DataService
    var sessionService: SessionServiceImpl
    var categoryType: String?
    private var cancellables: Set<AnyCancellable> = []
    @Published var gameNotification = GameNotfication.waitingForPlayer
    @Published private(set) var reachedEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var question: Trivia?
    @Published private(set) var answers: [Answer] = []
    @Published private(set) var totalScore = 0
    @State var isActive = true
    @Published var game: Game? {
        didSet {
            updateGameNotificationsFor(game)
        }
    }
    @Published var isPlayerOne = false
    @Published var results: String?

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(game: Game, sessionService: SessionServiceImpl, dataService: DataServiceImpl = .init()) {
        self.game = game
        print(game)
        self.sessionService = sessionService
        self.dataService = dataService
        self.updateGameNotificationsFor(self.game)
    }
    
    func checkGameState() {
        if game?.player1["id"] == "" && game?.player2["id"] != "" {
            startGameWithFriend()
            gameNotification = GameNotfication.waitingForPlayer
        } else if game?.winnerId != ""  {
            gameNotification = GameNotfication.gameHasFinished
        } else if game?.player2["id"] == "" && game?.player1["id"] == "" {
            startNewGame()
        } else if game?.player1["id"] == "" && game?.player2["id"] != ""{
            
        } else if game?.blockPlayerId == sessionService.userDetails?.id {
            resumeGame(with: game!.id)
            gameNotification = GameNotfication.opponentsTurn
        } else {
            resumeGame(with: game!.id)
            gameNotification = GameNotfication.yourTurn
        }
    }
    
    func updateGameNotificationsFor(_ state: Game?) {
        print("checking")
        if game?.player1["id"] == "" && game?.player2["id"] != "" {
            gameNotification = GameNotfication.waitingForPlayer
        } else if game?.winnerId != ""  {
            gameNotification = GameNotfication.gameHasFinished
        } else if game?.player2["id"] == "" {
            gameNotification = GameNotfication.waitingForPlayer
        } else if game?.blockPlayerId == sessionService.userDetails?.id {
            gameNotification = GameNotfication.opponentsTurn
        } else if game?.blockPlayerId != sessionService.userDetails?.id {
            gameNotification = GameNotfication.yourTurn
        }
    }
    
    @MainActor
    func getQuestions(for group: String, and type: String) {
        Task.init {
            questions = try await dataService.getQuestions(for: group, and: type)
            question = questions.randomElement()
            answers = question?.answers ?? [Answer(text: "", isCorrect: false)]
        }
    }
    
    func startNewGame() {
        TriviaService.shared.startRandomGame(with: sessionService.userDetails!, and: game!.groupName)
        TriviaService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    
    func startGameWithFriend() {
        TriviaService.shared.startGameWithFriend(with: sessionService.userDetails!, and: game!.player2, and: game!.groupName)
        TriviaService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    
    func resumeGame(with id: String) {
        print("resuming game!")
        TriviaService.shared.resumeGame(with: id)
        TriviaService.shared.$game
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
    }
    
    func updatePlayersScore(answer: Answer) {
        if answer.isCorrect && isPlayerOne {
            var score = Int(game?.player1Score ?? "") ?? 0
            score += 1
            game?.player1Score = String(score)
            
            if score == 3 {
                updateTotalScore()
                game?.player1Score = "0"
            }
            TriviaService.shared.updateGame(game!)
        } else if answer.isCorrect && !isPlayerOne {
            var score = Int(game?.player2Score ?? "") ?? 0
            score += 1
            game?.player2Score = String(score)
            if score == 3 {
                updateTotalScore()
                game?.player2Score = "0"
            }
            TriviaService.shared.updateGame(game!)
        } else if !answer.isCorrect && isPlayerOne {
            game?.player1Score = "0"
            game?.blockPlayerId = sessionService.userDetails?.id ?? ""
            TriviaService.shared.updateGame(game!)
        } else {
            game?.player2Score = "0"
            game?.blockPlayerId = sessionService.userDetails?.id ?? ""
            TriviaService.shared.updateGame(game!)
        }
        TriviaService.shared.listenForGameChanges(self.game!)
    }
    
    func updateTotalScore() {
        if totalScore == 3 {
            print("You have won the game")
            //endGame()
        }
        
        if isPlayerOne {
            var totalScore = Int(game?.player1TotalScore ?? "") ?? 0
            totalScore += 1
            game?.player1TotalScore = String(totalScore)
            TriviaService.shared.updateGame(game!)
        } else {
            var totalScore = Int(game?.player2TotalScore ?? "") ?? 0
            totalScore += 1
            game?.player2TotalScore = String(totalScore)
            game?.player2Score = "0"
        }
    }
    
    func resetGame() {
        game?.player1Score = "0"
        game?.player2Score = "0"
        game?.player1TotalScore = "0"
        game?.player2TotalScore = "0"
        TriviaService.shared.updateGame(game!)
    }

    func endGame() {
        print("The game is endingggggg")
        if isPlayerOne && game?.player1TotalScore == "3" {
            results = "YOU WON!"
            game?.winnerId = game?.player1["id"] ?? ""
            TriviaService.shared.updateGame(game!)
        } else if !isPlayerOne && game?.player2TotalScore == "3" {
            results = "YOU WON!"
            game?.winnerId = game?.player2["id"] ?? ""
            TriviaService.shared.updateGame(game!)
        } else {
            results = "YOU LOST :("
        }
        reachedEnd = true
    }
    
    
    func checkForGameStatus() -> Bool {
        return game != nil ? game?.blockPlayerId == sessionService.userDetails?.id : false
    }
    
    func checkIfUserIsPlayerOne() {
        if game?.player1["id"] == sessionService.userDetails?.id {
            isPlayerOne = true
        } else {
            isPlayerOne = false
        }
    }
    
//    func addNotificationForUser() {
//        let center = UNUserNotificationCenter.current()
//    }
    
    func deleteGame() {
        TriviaService.shared.deleteGame(with: game?.id ?? "", for: sessionService.userDetails!.id)
    }
}


