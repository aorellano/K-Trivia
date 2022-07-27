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
//    @Published var currentUser: SessionUserDetails?
    @Published var game: Game? {
        didSet {
            updateGameNotificationsFor(game)
        }
    }
    @Published var isPlayerOne = false
    @Published var results: String?

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
//    init(groupName: String, sessionService: SessionService, dataService: DataService = DataServiceImpl(), gameId: String, user: UserInfo) {
//        print("vieModel getting inilitized")
//        self.groupName = groupName
//        self.dataService = dataService
//        self.sessionService = sessionService
//        self.gameId = gameId
//        self.friend = user
//        self.retrieveUser()
//        self.checkIfUserIsPlayerOne()
//        self.checkIfGameIsOver()
//        self.checkIfFriendMatch()
//    }
    
    init(game: Game, sessionService: SessionServiceImpl, dataService: DataServiceImpl = .init()) {
        self.game = game
        print(game)
        self.sessionService = sessionService
        self.dataService = dataService
        self.updateGameNotificationsFor(self.game)
        //GameService.shared.listenForGameChanges(self.game!)
    }
    
    func checkGameState() {
        if game?.player1["id"] == "" && game?.player2["id"] != "" {
            startGameWithFriend()
            gameNotification = GameNotfication.waitingForPlayer
        } else if game?.winnerId != ""  {
            print(game?.winnerId)
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
            print("HI \(game?.winnerId)")
            gameNotification = GameNotfication.gameHasFinished
        } else if game?.player2["id"] == "" {
            gameNotification = GameNotfication.waitingForPlayer
           // GameService.shared.listenForGameChanges()
        } else if game?.blockPlayerId == sessionService.userDetails?.id {
            gameNotification = GameNotfication.opponentsTurn
           // GameService.shared.listenForGameChanges()
        } else if game?.blockPlayerId != sessionService.userDetails?.id {
            gameNotification = GameNotfication.yourTurn
           // GameService.shared.listenForGameChanges()
        }
    }
    
    func getQuestions(for group: String, and type: String) {
        dataService.getQuestions(for: group, and: type) {[weak self] questions in
            self?.questions = questions
            self?.question = questions.randomElement()
            self?.answers = self?.question?.answers ?? [Answer(text: "", isCorrect: false)]
        }
    }
    
    //should check if game object if nil if it is start new game
    //if not current game should resume
    func startNewGame() {
        GameService.shared.startRandomGame(with: sessionService.userDetails!, and: game!.groupName)
        GameService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    
    func startGameWithFriend() {
        print("starting game with friend")
     //   print(friend)
//        gameId = ""
//        guard let currentUser = currentUser else {
//            return
//        }
        GameService.shared.startGameWithFriend(with: sessionService.userDetails!, and: game!.player2, and: game!.groupName)
        GameService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    
    func resumeGame(with id: String) {
        print("resuming game!")
        GameService.shared.resumeGame(with: id)
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
            GameService.shared.updateGame(game!)
        } else if answer.isCorrect && !isPlayerOne {
            var score = Int(game?.player2Score ?? "") ?? 0
            score += 1
            game?.player2Score = String(score)
            if score == 3 {
                updateTotalScore()
                game?.player2Score = "0"
            }
            GameService.shared.updateGame(game!)
        } else if !answer.isCorrect && isPlayerOne {
            game?.player1Score = "0"
            game?.blockPlayerId = sessionService.userDetails?.id ?? ""
            GameService.shared.updateGame(game!)
        } else {
            game?.player2Score = "0"
            game?.blockPlayerId = sessionService.userDetails?.id ?? ""
            GameService.shared.updateGame(game!)
        }
        GameService.shared.listenForGameChanges(self.game!)
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
            //game?.player1Score = "0"
//            dataService.updateUsers(score: Int(game?.player1TotalScore ?? "1") ?? 1, with: game?.player1["id"] ?? "")
            GameService.shared.updateGame(game!)
        } else {
            var totalScore = Int(game?.player2TotalScore ?? "") ?? 0
            totalScore += 1
            game?.player2TotalScore = String(totalScore)
            game?.player2Score = "0"
//            dataService.updateUsers(score: Int(game?.player2TotalScore ?? "1") ?? 1, with: game?.player2["id"] ?? "")
            //GameService.shared.updateGame(game!)
        }
    }
    
    func resetGame() {
        game?.player1Score = "0"
        game?.player2Score = "0"
        game?.player1TotalScore = "0"
        game?.player2TotalScore = "0"
        GameService.shared.updateGame(game!)
    }

    func endGame() {
//        print("end of game")
//        updatePlayerScore(with: 0)
//        checkIfBothPlayersHaveFinished()
        print("The game is endingggggg")
        if isPlayerOne && game?.player1TotalScore == "3" {
            results = "YOU WON!"
            game?.winnerId = game?.player1["id"] ?? ""
            GameService.shared.updateGame(game!)
        } else if !isPlayerOne && game?.player2TotalScore == "3" {
            results = "YOU WON!"
            game?.winnerId = game?.player2["id"] ?? ""
            GameService.shared.updateGame(game!)
        } else {
            results = "YOU LOST :("
        }
        
        
        reachedEnd = true
    }
    
    
    func checkForGameStatus() -> Bool {
        return game != nil ? game?.blockPlayerId == sessionService.userDetails?.id : false
    }
    
    func checkIfGameIsOver() {
//        if game != nil || gameId != "" {
////            self.resumeGame(with: gameId ?? "")
//            print(game)
//            self.endGame()
//        }
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
//        currentUser = sessionService.userDetails
        //print("Current User: \(String(describing: currentUser))")
    }
    
    func checkIfUserIsPlayerOne() {
        if game?.player1["id"] == sessionService.userDetails?.id {
            isPlayerOne = true
        } else {
            isPlayerOne = false
        }
    }
    
    func addNotificationForUser() {
        let center = UNUserNotificationCenter.current()
    }
    
    func deleteGame() {
        GameService.shared.deleteGame(with: game?.id ?? "", for: sessionService.userDetails!.id)
    }
}


