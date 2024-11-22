//
//  GameState.swift
//  ghost
//
//  Created by Molly Sandler on 11/21/24.
//

import Foundation

struct GameState {
    var currentLetters: String
    var currentPlayerIndex: Int
    var players: [Player]
    
    var currentPlayer: Player {
        players[currentPlayerIndex]
    }
    
    var previousPlayer: Player {
        players[(currentPlayerIndex + players.count - 1) % players.count]
    }
    
    mutating func nextTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
    
    mutating func reset() {
        currentLetters = ""
        currentPlayerIndex = 0
    }
}
