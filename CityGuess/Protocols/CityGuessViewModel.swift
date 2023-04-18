//
//  CityGuessViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/17/23.
//

import Foundation

@MainActor
protocol CityGuessViewModel: ObservableObject {
    associatedtype CityModel: City
    associatedtype CityFetcher: CityFetching
    
    var cityImages: [CityImage] { get set }
    var score: Int { get set }
    var currentCityIndex: Int { get set }
    var isPlaying: Bool { get set }
    var isCorrect: Bool { get set }
    var priorAnswer: String { get set}
    var numberOfRounds: Int { get set }
    
    var cities: [CityModel] { get set }
    var isGameOver: Bool { get }
    var roundOptions: [Int] { get }
    var currentRound: Int { get }
    var cityService: CityService { get }
    var cityFetcher: CityFetcher { get }
    var roundLength: Int { get }
    
    var modeTitle: String { get }
    var gameHeadline: String { get }
    var gameDescription: String { get }
    var startGameButtonText: String { get }
    
    var scoreLabelText: String { get }
    var roundLabelText: String { get }
    
    var gameOverText: String { get }
    var gameOverScoreText: String { get }
    var tryAgainButtonText: String { get }
    
    func fetchCityImages() async
    func fetchCities() async
    func startGame(with numberOfRounds: Int)
    func endGame()
    func submit(guess: String)
    func autofillSuggestions(for guess: String) -> [CityModel]
    
    init(cityService: CityService, cityFetcher: CityFetcher)
}
