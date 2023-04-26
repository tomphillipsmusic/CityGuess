//
//  CityGuessViewModel+DefaultBehavior.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/17/23.
//

import Foundation

extension CityGuessViewModel {

    var isGameOver: Bool {
        currentCityIndex == numberOfRounds
    }

    var roundOptions: [Int] {
        [5, 10, 25]
    }

    var currentRound: Int {
        currentCityIndex + 1
    }

    var currentCityImage: CityImage {
        cityImages[currentCityIndex]
    }

    var scoreLabelText: String {
        "Score: \(score)"
    }

    var roundLabelText: String {
        "\(currentRound) / \(numberOfRounds)"
    }

    var gameOverText: String {
        "Game Over!"
    }

    var gameOverScoreText: String {
        "You guessed a total of \(score) cities correctly!"
    }

    var tryAgainButtonText: String {
        "Try Again"
    }

    func startGame(with numberOfRounds: Int) {
        self.numberOfRounds = numberOfRounds
        isPlaying = true
        score = 0
        cityImages.shuffle()
        priorAnswer = ""
        currentCityIndex = 0
        questions = resetQuestions()
    }

    func endGame() {
        isPlaying = false
        questions = resetQuestions()
    }

    private func resetQuestions() -> [Question] {
        (0..<numberOfRounds).map { Question(text: cityImages[$0].title) }
    }

    func submit(guess: String) {
        let title = cityImages[currentCityIndex].title

        if title.lowercased().contains(guess.lowercased()) {
            isCorrect = true
            score += 1
            HapticsManager.shared.correct()
        } else {
            isCorrect = false
            HapticsManager.shared.incorrect()
        }

        priorAnswer = title
        isShowingAnimation = true
    }

    func autofillSuggestions(for guess: String) -> [CityModel] {
        guard !guess.isEmpty else { return [] }
        let numberOfSuggestions = 8
        return cities.filterUniqueItems({ $0.name.lowercased().starts(with: guess.lowercased())}, limit: numberOfSuggestions)
    }

    func animationCompleted() {
        questions[currentCityIndex].state = isCorrect ? .correct : .incorrect
        currentCityIndex += 1
        isShowingAnimation = false
    }
}
