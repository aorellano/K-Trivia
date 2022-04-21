//
//  SpinViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/19/22.
//

import Foundation

class SpinWheelViewModel: ObservableObject {
    var gameService: GameService
    var sessionService: SessionService
    var dataService: DataService
    @Published var game: Game?
    @Published var currentUser: SessionUserDetails?
//    @Published var categoryTypes = [String]()
//    var dataService: DataService
//    var gameService: GameService
//
    init(groupName: String, sessionService: SessionService, gameService: GameService = GameServiceImpl(), dataService: DataService = DataServiceImpl()) {
        self.gameService = gameService
        self.sessionService = sessionService
        self.dataService = dataService
        self.retrieveUser()
    }
    
    func createGame() {
        gameService.startGame(with: currentUser!) { [weak self] game in
            self?.game = game
        }
    }
    
    func retrieveUser() {
        currentUser = sessionService.userDetails
    }
}
