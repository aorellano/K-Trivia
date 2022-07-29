//
//  GamesService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/13/22.
//

import Foundation


protocol GamesService {
    func getGames(with gameIds: [String]) async throws -> [Game]
}

class GamesServiceImpl: GamesService {
    func getGames(with gameIds: [String]) async throws -> [Game] {
        let snapshot = try await FirebaseReference(.game).whereField("id", in: gameIds).getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Game.self)
        }
    }
}
