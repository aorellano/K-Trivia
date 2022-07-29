//
//  GamesViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/13/22.
//

import Foundation

class GamesViewModel: ObservableObject {
    @Published var games = [Game]()
    
    var service: GamesService
    
    init(service: GamesService = GamesServiceImpl()) {
        self.service = service
   
    }
    
    @MainActor
    func fetchGames(with gameIds: [String]) async {
        Task.init {
            games = try await service.getGames(with: gameIds)
        }
    }
}
