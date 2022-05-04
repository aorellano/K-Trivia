//
//  GameNotifications.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/3/22.
//

import SwiftUI

enum GameState {
    case waitingForPlayer
    case opponentsTurn
    case yourTurn
    case finished
}

struct GameNotfication {
    static let waitingForPlayer = "Waiting for Player"
    static let gameHasFinished = "Game has Finished"
    static let opponentsTurn = "Opponents Turn..."
    static let yourTurn = "Your Turn!"
}
