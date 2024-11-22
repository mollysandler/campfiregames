import SwiftUI

struct ContentView: View {
    @State private var currentLetters = ""
    @State private var currentPlayerIndex = 0
    @State private var players = ["Player 1", "Player 2", "Player 3"]
    @State private var inputLetter = ""
    @State private var showingChallengeAlert = false
    @State private var showingResultAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Current Letters: \(currentLetters)")
                .font(.title)
                .padding()
            
            Text("Current Turn: \(players[currentPlayerIndex])")
                .font(.headline)
            
            TextField("Enter a letter", text: $inputLetter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 100)
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.never)
            
            Button("Submit Letter") {
                submitLetter()
            }
            .disabled(inputLetter.isEmpty)
            
            Button("Challenge") {
                showingChallengeAlert = true
            }
            .disabled(currentLetters.isEmpty)
        }
        .padding()
        .alert("Challenge", isPresented: $showingChallengeAlert) {
            TextField("Enter your word", text: $inputLetter)
            Button("Submit") {
                handleChallenge(word: inputLetter.lowercased())
            }
            Button("Cancel", role: .cancel) {
                inputLetter = ""
            }
        } message: {
            Text("\(players[(currentPlayerIndex + players.count - 1) % players.count]), enter a word using these letters: \(currentLetters)")
        }
        .alert("Result", isPresented: $showingResultAlert) {
            Button("OK") {
                if alertMessage.contains("loses") {
                    resetGame()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func submitLetter() {
        guard let letter = inputLetter.lowercased().first,
              letter.isLetter else {
            alertMessage = "Please enter a valid letter"
            showingResultAlert = true
            return
        }
        
        // Add the new letter
        let newLetters = currentLetters + String(letter)
        
        // Check if the current letters form a word
        if isValidWord(newLetters) && newLetters.count >= 4 {  // Only check words of 4 or more letters
            alertMessage = "\(players[currentPlayerIndex]) loses! '\(newLetters)' is a valid word!"
            showingResultAlert = true
            return
        }
        
        // If we get here, it's not a word, so continue the game
        currentLetters = newLetters
        inputLetter = ""
        nextTurn()
    }
    
    private func isValidWord(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word,
                                                           range: range,
                                                           startingAt: 0,
                                                           wrap: false,
                                                           language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    private func handleChallenge(word: String) {
        if isValidWord(word) {
            let previousPlayerIndex = (currentPlayerIndex + players.count - 1) % players.count
            alertMessage = "\(players[previousPlayerIndex]) loses! '\(word)' is a valid word!"
        } else {
            alertMessage = "Not a valid word. Challenger loses!"
        }
        
        showingResultAlert = true
        inputLetter = ""
    }
    
    private func nextTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
    
    private func resetGame() {
        currentLetters = ""
        currentPlayerIndex = 0
        inputLetter = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
