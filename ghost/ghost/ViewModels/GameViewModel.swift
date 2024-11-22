//
//  GameViewModel.swift
//  ghost
//
//  Created by Molly Sandler on 11/21/24.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private(set) var gameState: GameState
    @Published var inputLetter = ""
    @Published var showingChallengeAlert = false
    @Published var showingResultAlert = false
    @Published var alertMessage = ""
    
    init() {
        let initialPlayers = [
            Player(name: "Player 1"),
            Player(name: "Player 2"),
            Player(name: "Player 3")
        ]
        self.gameState = GameState(
            currentLetters: "",
            currentPlayerIndex: 0,
            players: initialPlayers
        )
    }
    
    var currentLetters: String { gameState.currentLetters }
    var currentPlayer: Player { gameState.currentPlayer }
    
    func submitLetter() {
        guard let letter = inputLetter.lowercased().first,
              letter.isLetter else {
            showAlert(message: "Please enter a valid letter")
            return
        }
        
        let newLetters = currentLetters + String(letter)
        
        if WordValidator.isValidWord(newLetters) {
            showAlert(message: "\(currentPlayer.name) loses! '\(newLetters)' is a valid word!")
            return
        }
        
        gameState.currentLetters = newLetters
        inputLetter = ""
        gameState.nextTurn()
    }
    
    func handleChallenge(word: String) {
        if WordValidator.isValidWord(word) {
            showAlert(message: "\(gameState.previousPlayer.name) loses! '\(word)' is a valid word!")
        } else {
            showAlert(message: "Not a valid word. Challenger loses!")
        }
        inputLetter = ""
    }
    
    func resetGame() {
        gameState.reset()
        inputLetter = ""
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showingResultAlert = true
    }
}