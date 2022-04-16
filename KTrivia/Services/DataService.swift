//
//  AppDataService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol DataService {
    func getGroups(completion: @escaping ([String]) -> Void)
    func getQuestions(for group: String, completion: @escaping ([Trivia]) -> Void)
    func createOnlineGame()
    func startGame(with userId: String, completion: @escaping ((Game) -> Void))
    func updateGame(_ game: Game)
    func listenForGameChanges()
    func createNewGame(with UserId: String)
    func quitTheGame()
    func updatePlayer1Score(_ score: String)
    func updatePlayer2Score(_ score: String)
    var game: Game! { get set }
}

class FirebaseService: DataService {
   
    private let db = Firestore.firestore()
    @Published var groups = [String]()
    @Published var questions = [Trivia]()
    @Published var game: Game!
    
   
    func getGroups(completion: @escaping ([String]) -> Void) {
        print("getting groups")
        db
            .collection("questions")
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.groups = documents.map { (queryDocumentSnapshot) -> String in
            let data = queryDocumentSnapshot.data()
            let category = data["category"] as? String ?? ""
            return category
            }.removeDuplicates().filter({$0 != ""})
            
            completion(
                self.groups
            )
        }
    }
    
    func getQuestions(for group: String, completion: @escaping ([Trivia]) -> Void) {
        
        db.collection("questions").whereField("category", isEqualTo: group)
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.questions = documents.map { (queryDocumentSnapshot) -> Trivia in
                let data = queryDocumentSnapshot.data()
                let category = data["category"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let question = data["question"] as? String ?? ""
                let correctAnswer = data["correct_answer"] as? String ?? ""
                let incorrectAnswers = data["incorrect_answers"] as? [String] ?? [""]
                
                let triviaQuestion = Trivia(category: category, type: type, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
                
                return triviaQuestion
            }
            
            completion(
                self.questions
            )
        }
    }
    
    func createOnlineGame() {
        //save the game online
        do {
            try db.collection("game").document(self.game.id).setData([
                "id": self.game.id,
                "player1Id": self.game.player1Id,
                "player2Id": self.game.player2Id,
                "player1Score": self.game.player1Score,
                "player2Score": self.game.player2Score,
                "winnerPlayerId": self.game.winnerPlayerId
            ])
        }
    }
    
    func startGame(with userId: String, completion: @escaping ((Game) -> Void)) {
        //check if there is a game to join, if no, we create new game.
        //If yes, we will join and start listening for any changes in the game.
        db.collection("game")
            .whereField("player2Id", isEqualTo: "")
            .whereField("player1Id", isNotEqualTo: userId)
            .getDocuments { querySnapshot, error in
                if error != nil {
                    //create new game
                    print("Error starting game", error?.localizedDescription)
                    self.createNewGame(with: userId)
                    return
                }

                if let gameData = querySnapshot?.documents.first {
                    self.game = try? gameData.data(as: Game.self)
                    self.game.player2Id = userId
                    self.updateGame(self.game)
                    self.listenForGameChanges()
                } else {
                    self.createNewGame(with: userId)
                }
                
                    completion(
                        self.game
                    )
            }
        }
    
    func createNewGame(with userId: String) {
        //create new game object
        print("creating game for \(userId)")
        self.game = Game(id: UUID().uuidString, player1Id: userId, player2Id: "", player1Score: "", player2Score: "", winnerPlayerId: "")
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func updatePlayer1Score(_ score: String) {
        do {
            try db.collection("game").document(self.game.id).setData([
                "id": self.game.id,
                "player1Id": self.game.player1Id,
                "player2Id": self.game.player2Id,
                "player1Score": score,
                "player2Score": self.game.player2Score,
                "winnerPlayerId": self.game.winnerPlayerId
                
            ])
            


        }
        

        
        
    }
    
    func updatePlayer2Score(_ score: String) {
        do {
            try db.collection("game").document(self.game.id).setData([
                "id": self.game.id,
                "player1Id": self.game.player1Id,
                "player2Id": self.game.player2Id,
                "player1Score": self.game.player1Score,
                "player2Score": score,
                "winnerPlayerId": self.game.winnerPlayerId
            ])
            


        }
    }

    
    func updateGame(_ game: Game) {
        print("... updating game")
        do {
            try db.collection("game").document(game.id).setData(from: game)
        } catch {
            print("Error creating online game \(error.localizedDescription)")
        }
    }
    
    func listenForGameChanges() {
        db.collection("game").document(self.game.id).addSnapshotListener { [self] documentSnapshot, error in
            print("changes recieved from firebase")

            if error != nil {
                print("Error listening to changes \(error?.localizedDescription)")
            }
            
            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: Game.self)
            }
        }
    }
    

    
    

    
    func quitTheGame() {
        //
    }
}
