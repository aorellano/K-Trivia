//
//  MockDataService.swift
//  KTriviaTests
//
//  Created by Alexis Orellano on 3/11/22.
//

import Foundation

@testable import KTrivia

final class MockGamesService: GamesService {
    var mockGames = [
        Game(id: "id1", groupName: "group1", player1: ["":""], player2: ["":""], player1Score: "0", player2Score: "0", player1TotalScore: "0", player2TotalScore: "0", blockPlayerId: "id2", winnerId: "id1"),
        Game(id: "id2", groupName: "group1", player1: ["":""], player2: ["":""], player1Score: "0", player2Score: "0", player1TotalScore: "0", player2TotalScore: "0", blockPlayerId: "id2", winnerId: "id1")
    ]
    
    func getGames(with gameIds: [String]) async throws -> [Game] {
        return mockGames.filter({$0.id == gameIds.first!})
    }
}
