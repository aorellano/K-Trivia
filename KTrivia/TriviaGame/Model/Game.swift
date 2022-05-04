//
//  Game.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/11/22.
//

import Foundation

struct Game: Codable {
    let id: String
    var player1: [String: String]
    var player2: [String: String]
    var player1Score: String
    var player2Score: String
    var player1TotalScore: String
    var player2TotalScore: String
    var blockPlayerId: String
    var winnerId: String
}
