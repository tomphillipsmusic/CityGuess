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
        filteredCityImages[currentCityIndex]
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
        let cities = score == 1 ? "city" : "cities"

        return "You guessed a total of \(score) \(cities) correctly!"
    }

    var gameEndText: String {
        "Return to Menu"
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

    func resetQuestions() -> [Question] {
        (0..<numberOfRounds).map { Question(text: filteredCityImages[$0].title) }
    }

    func submit(guess: String) {
        let title = currentCityImage.title

        if title.caseInsensitiveContains(guess) {
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

    func autofillSuggestions(for guess: String) -> [CGCity] {
        guard !guess.isEmpty else { return [] }
        let numberOfSuggestions = 8
        return cities.filterUniqueItems({ $0.name.caseInsensitiveStarts(with: guess) }, limit: numberOfSuggestions)
    }

    func animationCompleted() {
        questions[currentCityIndex].state = isCorrect ? .correct : .incorrect
        currentCityIndex += 1
        isShowingAnimation = false
    }

    var gameProgress: CGFloat {
        CGFloat(currentCityIndex) / CGFloat(numberOfRounds)
    }

    func totalNumberOfCities(in continent: CGContinent) -> Int {
        if continent == .all {
            return cities.count
        } else {
            return cities.filter { $0.continent == continent }.count
        }
    }
}
