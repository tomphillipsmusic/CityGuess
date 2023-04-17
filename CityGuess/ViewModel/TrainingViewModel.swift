//
//  CityGuessViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

@MainActor
protocol CityGuessViewModel: ObservableObject {
    associatedtype CityModel: City
    
    var cityImages: [CityImage] { get }
    var cityImagesPublished: Published<[CityImage]> { get }
    var cityImagesPublisher: Published<[CityImage]>.Publisher { get }
    
    var score: Int { get }
    var scorePublished: Published<Int> { get }
    var scorePublisher: Published<Int>.Publisher { get }
    
    var currentCityIndex: Int { get }
    var currentCityIndexPublished: Published<Int> { get }
    var currentCityIndexPublisher: Published<Int>.Publisher { get }
    
    var isPlaying: Bool { get }
    var isPlayingPublished: Published<Bool> { get }
    var isPlayingPublisher: Published<Bool>.Publisher { get }
    
    var isCorrect: Bool { get }
    var isCorrectPublished: Published<Bool> { get }
    var isCorrectPublisher: Published<Bool>.Publisher { get }
    
    var priorAnswer: String { get }
    var priorAnswerPublished: Published<String> { get }
    var priorAnswerPublisher: Published<String>.Publisher { get }
    
    var numberOfRounds: Int { get }
    var numberOfRoundsPublished: Published<Int> { get }
    var numberOfRoundsPublisher: Published<Int>.Publisher { get }
    
    var cities: [CityModel] { get }
    var isGameOver: Bool { get }
    var roundOptions: [Int] { get }
    var currentRound: Int { get }
    var cityService: CityService { get }
    var cityFetcher: any CityFetching { get }
    
    func fetchCityImages() async
    func fetchCities() async
    func startGame(with numberOfRounds: Int)
    func endGame()
    func submit(guess: String)
    func autofillSuggestions(for guess: String) -> [CityModel]
}

extension CityGuessViewModel {
    #warning("Continue experimenting with making protocol to extend view model, if that don't work, maybe check out inheritance?")
}

@MainActor
class TrainingViewModel<T: City>: CityGuessViewModel {
    
    @Published private(set) var cityImages = [CityImage]()
    var cityImagesPublished: Published<[CityImage]> { _cityImages }
    var cityImagesPublisher: Published<[CityImage]>.Publisher { $cityImages }
    
    @Published private(set) var score = 0
    var scorePublished: Published<Int> { _score }
    var scorePublisher: Published<Int>.Publisher { $score }
    
    @Published private(set) var currentCityIndex = 0
    var currentCityIndexPublished: Published<Int> { _currentCityIndex }
    var currentCityIndexPublisher: Published<Int>.Publisher { $currentCityIndex }
    
    @Published private(set) var isPlaying = false
    var isPlayingPublished: Published<Bool> { _isPlaying }
    var isPlayingPublisher: Published<Bool>.Publisher { $isPlaying }
    
    @Published private(set) var isCorrect = false
    var isCorrectPublished: Published<Bool> { _isCorrect }
    var isCorrectPublisher: Published<Bool>.Publisher { $isCorrect }
    
    @Published private(set) var priorAnswer = ""
    var priorAnswerPublished: Published<String> { _priorAnswer }
    var priorAnswerPublisher: Published<String>.Publisher { $priorAnswer }
    
    @Published var numberOfRounds = 5
    var numberOfRoundsPublished: Published<Int> { _numberOfRounds }
    var numberOfRoundsPublisher: Published<Int>.Publisher { $numberOfRounds }
    
    private(set) var cities: [T] = []
    let cityService: CityService
    let cityFetcher: any CityFetching
    private let roundLength = 10
    
    init(cityService: CityService = LocalCityService(), cityFetcher: any CityFetching = TeleportApiClient()) {
        self.cityService = cityService
        self.cityFetcher = cityFetcher
        
        Task {
            await fetchCities()
            await fetchCityImages()
        }
    }
    
    var isGameOver: Bool {
        currentCityIndex == roundLength
    }
    
    var roundOptions: [Int] {
        [5, 10, 25, 50, 100, cities.count]
    }
    
    var currentRound: Int {
        currentCityIndex + 1
    }
        
    func fetchCityImages() async {
        do {
            if let cityImages = try? cityService.loadImages() {
                self.cityImages = cityImages.shuffled()
            } else {
                cityImages = try await cityFetcher.fetchCityImages().shuffled()
                cityService.save(cityImages)
            }
            
            print("City images count: " + "\(cityImages.count)")
        } catch {
            print(error)
        }
    }
    
    func fetchCities() async {
        if let cities: [T] = try? cityService.loadCities() {
            self.cities = cities
        } else if let cities = try? await cityFetcher.fetchCities() as? [T] {
            self.cities = cities
            try? cityService.save(cities)
        }
    }
    
    func startGame(with numberOfRounds: Int) {
        self.numberOfRounds = numberOfRounds
        isPlaying = true
        score = 0
        cities.shuffle()
        priorAnswer = ""
        currentCityIndex = 0
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
        currentCityIndex += 1
    }

    func autofillSuggestions(for guess: String) -> [T] {
        guard !guess.isEmpty else { return [] }
        let numberOfSuggestions = 5
        return cities.filterUniqueItems({ $0.name.starts(with: guess)}, limit: numberOfSuggestions)
    }
}
