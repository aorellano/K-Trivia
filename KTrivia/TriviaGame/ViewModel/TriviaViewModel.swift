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
    @Published var gameId: String
    private var cancellables: Set<AnyCancellable> = []
    @Published var gameNotification = GameNotfication.waitingForPlayer
    @Published private(set) var reachedEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var question: Trivia?
    @Published private(set) var answers: [Answer] = []
    @Published private(set) var totalScore = 0
    @Published private(set) var groupName: String
    @State var isActive = true
    @Published var currentUser: SessionUserDetails?
    var friend: UserInfo
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

    
    init(groupName: String, sessionService: SessionService, dataService: DataService = DataServiceImpl(), gameId: String, user: UserInfo) {
        print("vieModel getting inilitized")
        self.groupName = groupName
        self.dataService = dataService
        self.sessionService = sessionService
        self.gameId = gameId
        self.friend = user
        self.retrieveUser()
        self.checkIfUserIsPlayerOne()
        self.checkIfGameIsOver()
        self.checkIfFriendMatch()
    }
    
    func checkIfFriendMatch() {
        if friend.id != "" {
            print(friend.id)
            print("this is a friend match")
        }
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
    
    //should check if game object if nil if it is start new game
    //if not current game should resume
    func startRandomGame() {
        print("starting random game")
        guard let currentUser = currentUser else {
            return
        }

        GameService.shared.startRandomGame(with: currentUser, and: groupName)
        GameService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
        
    }
    
    func startGameWithFriend() {
        print("starting game with friend")
        print(friend)
        guard let currentUser = currentUser else {
            return
        }
        GameService.shared.startGameWithFriend(with: currentUser, and: friend, and: groupName)
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
            game?.blockPlayerId = currentUser?.id ?? ""
            GameService.shared.updateGame(game!)
        } else {
            game?.player2Score = "0"
            game?.blockPlayerId = currentUser?.id ?? ""
            GameService.shared.updateGame(game!)
        }
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
            dataService.updateUsers(score: Int(game?.player1TotalScore ?? "1") ?? 1, with: game?.player1["id"] ?? "")
            GameService.shared.updateGame(game!)
        } else {
            var totalScore = Int(game?.player2TotalScore ?? "") ?? 0
            totalScore += 1
            game?.player2TotalScore = String(totalScore)
            game?.player2Score = "0"
            dataService.updateUsers(score: Int(game?.player2TotalScore ?? "1") ?? 1, with: game?.player2["id"] ?? "")
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
        
        return game != nil ? game?.blockPlayerId == currentUser?.id : false
           
    }
    
    func checkIfGameIsOver() {
        if game != nil || gameId != "" {
            self.resumeGame(with: gameId ?? "")
            print(game)
            self.endGame()
        }
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


