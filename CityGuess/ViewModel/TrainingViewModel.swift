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
    
    func fetchCityImages() async
    func fetchCities() async
    func startGame(with numberOfRounds: Int)
    func endGame()
    func submit(guess: String)
    func autofillSuggestions(for guess: String) -> [CityModel]
    
    init(cityService: CityService, cityFetcher: CityFetcher)
}

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
    
    func autofillSuggestions(for guess: String) -> [CityModel] {
        guard !guess.isEmpty else { return [] }
        let numberOfSuggestions = 5
        return cities.filterUniqueItems({ $0.name.starts(with: guess)}, limit: numberOfSuggestions)
    }
}

@MainActor
class TrainingViewModel: CityGuessViewModel {
    @Published var cityImages = [CityImage]()
    @Published var score = 0
    @Published var currentCityIndex = 0
    @Published var isPlaying = false
    @Published var isCorrect = false
    @Published var priorAnswer = ""
    @Published var numberOfRounds = 5
    
    var cities: [TeleportCity] = []
    let cityService: CityService
    let cityFetcher: TeleportApiClient
    let roundLength = 10
    
    var modeTitle: String = "Training"
    var gameHeadline: String = "Do you have what it takes to be a true City Guesser?"
    var gameDescription: String = "Take a spin through our images of famous cities from around the world and do your best to guess the name of the city!"
    
    required init(cityService: CityService = LocalCityService(), cityFetcher: TeleportApiClient = TeleportApiClient()) {
        self.cityService = cityService
        self.cityFetcher = cityFetcher
        
        Task {
            await fetchCities()
            await fetchCityImages()
        }
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
        if let cities: [CityModel] = try? cityService.loadCities() {
            self.cities = cities
        } else if let cities = try? await cityFetcher.fetchCities() {
            self.cities = cities
            try? cityService.save(cities)
        }
    }
}

@MainActor
class DailyChallengeViewModel: CityGuessViewModel {
    @Published var cityImages = [CityImage]()
    @Published var score = 0
    @Published var currentCityIndex = 0
    @Published var isPlaying = false
    @Published var isCorrect = false
    @Published var priorAnswer = ""
    @Published var numberOfRounds = 5
     
    var cities: [GeoNamesCity] = []
    let cityService: CityService
    let cityFetcher: RedditClient
    let roundLength = 10

    var modeTitle: String = "Daily Challenge"
    var gameHeadline: String = "Do you have what it takes to take on the Daily Challenge?"
    var gameDescription: String = "Check in once a day to see some of the latest and greatest city photos from around the world. How many can you guess??"
    
    required init(cityService: CityService = LocalCityService(), cityFetcher: RedditClient = RedditClient()) {
        self.cityService = cityService
        self.cityFetcher = cityFetcher
        
        Task {
            await fetchCities()
            await fetchCityImages()
        }
    }
    
    func fetchCityImages() async {
        do {
            cityImages = try await cityFetcher.fetchCityImages().shuffled()
            
            print("City images count: " + "\(cityImages.count)")
        } catch {
            print(error)
        }
    }
    
    func fetchCities() async {
        if let cities = try? await cityFetcher.fetchCities() {
            self.cities = cities
        }
    }
}
