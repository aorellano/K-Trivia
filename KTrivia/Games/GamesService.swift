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
//    func getGames(with gameIds: [String], completion: @escaping([Game]) -> Void) {
//        FirebaseReference(.game).whereField("id", in: gameIds).getDocuments{ snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            let games = documents.compactMap({ try? $0.data(as: Game.self)})
//            completion(games)
//        }
//    }
}
