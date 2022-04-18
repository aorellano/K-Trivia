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
    @Published var results: String?
    @Published var username: String?
    @Published var opponentUsername = "Opponent"
    @Published var yourScore: String?
    @Published var opponentScore: String?
    @Published var isPlayerOne: Bool?
    @Published var player2: User?
    @Published var player1: User?
    
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
//        print("endgame")
//            if game?.player1Id == currentUser {
//                dataService.updatePlayer1Score(String(score))
//                isPlayerOne = true
//
//                    dataService.findPlayer1Information(game?.player1Id ?? "") { [weak self] player1 in
//                        print("Here i am assigning player 2 \(player1)")
//                        self?.player1 = player1
//
//                }
//                print("end of game my current user id is \(currentUser)")
//                print("end of game player 1id is \(game?.player1Id ?? "")")
//            } else {
//
//                    dataService.findPlayer2Information(game?.player2Id ?? "") { [weak self] player2 in
//                        print("Here i am assigning player 2 \(player2)")
//                        self?.player2 = player2
//                    }
//
//
//                dataService.updatePlayer2Score(String(score))
//                isPlayerOne = false
//                print("end of game player 2 id is \(game?.player2Id)")
//            }
//
//        checkIfGameIsOver()
//        reachedEnd = true
    }
    
    func checkIfGameIsOver() {
        guard game != nil else { return }
        print("checking game")
        if isPlayerOne ?? true {
            yourScore = gameService.game?.player1Score
            opponentScore = gameService.game?.player2Score
        } else {
            yourScore = gameService.game?.player2Score
            opponentScore = gameService.game?.player1Score
        }
        
        if gameService.game?.player1Score != "" && gameService.game?.player2Score != "" {
            if isPlayerOne! && gameService.game.player1Score > gameService.game.player2Score {
                results = "YOU WON! :)"
            } else if gameService.game.player1Score == gameService.game.player2Score {
                results = "TIE!"
            } else {
                results = "YOU LOST! :("
            }
        }
    }
    

    func retrieveUser() {
        currentUser = sessionService.userDetails
        username = sessionService.userDetails?.username
        print("Current User: \(String(describing: currentUser))")
    }
}


