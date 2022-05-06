//
//  SpinViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/19/22.
//

import Foundation

class SpinWheelViewModel: ObservableObject {
    var sessionService: SessionService
    var dataService: DataService
    @Published var game: Game?
    @Published var currentUser: SessionUserDetails?
//    @Published var categoryTypes = [String]()
//    var dataService: DataService
//    var gameService: GameService
//
    init(groupName: String, sessionService: SessionService, dataService: DataService = DataServiceImpl()) {
        self.sessionService = sessionService
        self.dataService = dataService
        self.retrieveUser()
    }
    
    func createGame(with groupName: String) {
        GameService.shared.startGame(with: currentUser!, and: groupName)
    }
    
    func retrieveUser() {
        currentUser = sessionService.userDetails
    }
}
