//
//  CustomButton.swift
//  ghost
//
//  Created by Molly Sandler on 11/21/24.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    let isDisabled: Bool
    
    init(title: String, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isDisabled ? GameColors.secondaryText : GameColors.text)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isDisabled ? GameColors.card : GameColors.accent)
                )
        }
        .disabled(isDisabled)
    }
}

// Views/Components/CustomTextField.swift
import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .background(GameColors.card)
            .cornerRadius(12)
            .foregroundColor(GameColors.text)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(GameColors.accent, lineWidth: 1)
            )
    }
}
