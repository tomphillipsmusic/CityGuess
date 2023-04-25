//
//  CityGuessViewModel+DefaultBehavior.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/17/23.
//

import Foundation

extension CityGuessViewModel {

    var isGameOver: Bool {
        currentCityIndex == roundLength
    }

    var roundOptions: [Int] {
        [5, 10, 25, 50, 100, cities.count]
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
        questions = (0..<roundLength).map { Question(text: cityImages[$0].title) }
    }

    func endGame() {
        isPlaying = false
    }

    func submit(guess: String) {
        let title = cityImages[currentCityIndex].title

        if title.lowercased().contains(guess.lowercased()) {
            isCorrect = true
            score += 1
        } else {
            isCorrect = false
        }

        priorAnswer = title
        isShowingAnimation = true
    }

    func autofillSuggestions(for guess: String) -> [CityModel] {
        guard !guess.isEmpty else { return [] }
        let numberOfSuggestions = 8
        return cities.filterUniqueItems({ $0.name.starts(with: guess)}, limit: numberOfSuggestions)
    }

    func animationCompleted() {
        questions[currentCityIndex].state = isCorrect ? .correct : .incorrect
        currentCityIndex += 1
        isShowingAnimation = false
    }
}
