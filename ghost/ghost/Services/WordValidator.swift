//
//  WordValidator.swift
//  ghost
//
//  Created by Molly Sandler on 11/21/24.
//

import Foundation
import UIKit

struct WordValidator {
    static func isValidWord(_ word: String) -> Bool {
        guard word.count >= 4 else { return false }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )
        return misspelledRange.location == NSNotFound
    }
}
