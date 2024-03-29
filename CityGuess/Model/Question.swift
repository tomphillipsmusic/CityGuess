//
//  Answer.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/25/23.
//

import SwiftUI

struct Question: Identifiable {
    let id = UUID()
    var state = State.notAnswered
    let text: String

    var color: Color {
        switch state {

        case .correct:
            return .green
        case .incorrect:
            return .red
        case .notAnswered:
            return .gray.opacity(0.3)
        }
    }

    enum State {
        case correct, incorrect, notAnswered
    }
}

extension Question {
    static let testData = [
        Question(state: .correct, text: "New York"),
        Question(state: .incorrect, text: "New Brunswick"),
        Question(state: .correct, text: "New Jersey"),
        Question(state: .incorrect, text: "New Detroit"),
        Question(state: .correct, text: "New Los Angeles"),
        Question(state: .incorrect, text: "NewFoundland")
    ]
}
