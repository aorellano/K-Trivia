//
//  GamesViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/13/22.
//

import Foundation

class GamesViewModel: ObservableObject {
    @Published var games = [Game]()
    @Published private(set) var isRefreshing = true
    
    var service: GamesService
    
    init(service: GamesService = GamesServiceImpl()) {
        self.service = service
       // isRefreshing = true
    }
    
    @MainActor
    func fetchGames(with gameIds: [String]) async {
        
        defer {
            isRefreshing = false
        }
        Task.init {
            games = try await service.getGames(with: gameIds)
        }
    }
}
