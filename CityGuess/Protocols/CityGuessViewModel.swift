//
//  CityGuessViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/17/23.
//

import Foundation

@MainActor
protocol CityGuessViewModel: ObservableObject, GameLogic, GameMode {
    associatedtype CityModel: City
    associatedtype CityFetcher: CityFetching

    var cityImages: [CityImage] { get set }
    var currentCityIndex: Int { get set }
    var cities: [CityModel] { get set }
    var cityService: CityService { get }
    var cityFetcher: CityFetcher { get }

    func fetchCityImages() async
    func fetchCities() async
    func autofillSuggestions(for guess: String) -> [CityModel]

    init(cityService: CityService, cityFetcher: CityFetcher)
}

@MainActor
protocol GameMode: ObservableObject {
    var modeTitle: String { get }
    var gameHeadline: String { get }
    var gameDescription: String { get }
    var startGameButtonText: String { get }

    var scoreLabelText: String { get }
    var roundLabelText: String { get }

    var gameOverText: String { get }
    var gameOverScoreText: String { get }
    var tryAgainButtonText: String { get }
}

@MainActor
protocol GameLogic: ObservableObject {
    func startGame(with numberOfRounds: Int)
    func endGame()
    func submit(guess: String)

    var score: Int { get set }
    var numberOfRounds: Int { get set }
    var roundLength: Int { get }
    var roundOptions: [Int] { get }
    var currentRound: Int { get }
    var isPlaying: Bool { get set }
    var isCorrect: Bool { get set }
    var isGameOver: Bool { get }
    var priorAnswer: String { get set}
}
