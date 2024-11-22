//
//  GameView.swift
//  ghost
//
//  Created by Molly Sandler on 11/21/24.
//

import SwiftUI

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    private let letterSpacing: CGFloat = 8
    
    var body: some View {
        ZStack {
            GameColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                header
                lettersDisplay
                currentPlayerDisplay
                inputSection
                buttons
                Spacer()
            }
            .padding()
        }
        .alert("Challenge", isPresented: $viewModel.showingChallengeAlert) {
            challengeAlert
        } message: {
            Text("\(viewModel.gameState.previousPlayer.name), enter a word using these letters: \(viewModel.currentLetters)")
        }
        .alert("Result", isPresented: $viewModel.showingResultAlert) {
            resultAlert
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    private var header: some View {
        Text("GHOST")
            .font(.system(size: 48, weight: .bold, design: .rounded))
            .foregroundColor(GameColors.text)
            .padding(.top, 40)
    }
    
    private var lettersDisplay: some View {
        VStack(spacing: 10) {
            Text("Current Word")
                .font(.subheadline)
                .foregroundColor(GameColors.secondaryText)
            
            HStack(spacing: letterSpacing) {
                ForEach(Array(viewModel.currentLetters), id: \.self) { letter in
                    Text(String(letter).uppercased())
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(GameColors.accent)
                }
            }
            .frame(minHeight: 40)
            .padding(.vertical)
            .padding(.horizontal, 20)
            .background(GameColors.card)
            .cornerRadius(20)
        }
    }
    
    private var currentPlayerDisplay: some View {
        VStack(spacing: 8) {
            Text("Current Turn")
                .font(.subheadline)
                .foregroundColor(GameColors.secondaryText)
            
            Text(viewModel.currentPlayer.name)
                .font(.title2.bold())
                .foregroundColor(GameColors.text)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(GameColors.card)
        .cornerRadius(15)
    }
    
    private var inputSection: some View {
        VStack(spacing: 8) {
            Text("Enter a letter")
                .font(.subheadline)
                .foregroundColor(GameColors.secondaryText)
            
            CustomTextField(placeholder: "Type here", text: $viewModel.inputLetter)
                .frame(width: 120)
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.never)
        }
    }
    
    private var buttons: some View {
        VStack(spacing: 16) {
            CustomButton(
                title: "Submit Letter",
                isDisabled: viewModel.inputLetter.isEmpty
            ) {
                viewModel.submitLetter()
            }
            
            CustomButton(
                title: "Challenge",
                isDisabled: viewModel.currentLetters.isEmpty
            ) {
                viewModel.showingChallengeAlert = true
            }
        }
        .padding(.horizontal)
    }
    
    private var challengeAlert: some View {
        Group {
            TextField("Enter your word", text: $viewModel.inputLetter)
                .textInputAutocapitalization(.never)
            Button("Submit") {
                viewModel.handleChallenge(word: viewModel.inputLetter.lowercased())
            }
            Button("Cancel", role: .cancel) {
                viewModel.inputLetter = ""
            }
        }
    }
    
    private var resultAlert: some View {
        Button("OK") {
            if viewModel.alertMessage.contains("loses") {
                viewModel.resetGame()
            }
        }
    }
}

// Preview
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
