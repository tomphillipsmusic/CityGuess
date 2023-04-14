//
//  CityGuessViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

@MainActor
class TrainingViewModel<T: City>: ObservableObject {
    @Published private(set) var cityImages = [CityImage]()
    @Published private(set) var score = 0
    @Published private(set) var currentCityIndex = 0
    @Published private(set) var isPlaying = false
    @Published private(set) var isCorrect = false
    @Published private(set) var priorAnswer = ""
    @Published var numberOfRounds = 5
    
    private var cities: [T] = []
    private let cityService: CityService
    private let cityFetcher: any CityFetching
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
