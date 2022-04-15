//
//  Game.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/11/22.
//

import Foundation

struct Game: Codable {
    let id: String
    var player1Id: String
    var player2Id: String
    var player1Score: String
    var player2Score: String
    var winnerPlayerId: String
}
