//
//  CityGuessViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

@MainActor
class CityGuessViewModel<T: City>: ObservableObject {
    @Published private(set) var cityImages = [CityImage]()
    @Published private(set) var score = 0
    @Published private(set) var currentCityIndex = 0
    @Published private(set) var isPlaying = false
    @Published private(set) var isCorrect = false
    @Published private(set) var priorAnswer = ""
    
    private var cities: [T] = []
    private let cityService: CityService
    private let cityFetcher: any CityFetching
    
    init(cityService: CityService = LocalCityService(), cityFetcher: any CityFetching = TeleportApiClient()) {
        self.cityService = cityService
        self.cityFetcher = cityFetcher
        
        Task {
            
            if let cities = try? await cityFetcher.fetchCities() as? [T] {
                self.cities = cities
                try cityService.save(cities)
                print("Cities Count: " + "\(cities.count)")
                
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
        }
        
    }
        
    func fetchCityImages() async {
        try? await cityImages = cityFetcher.fetchCityImages()
    }
    
    func fetchCities() async {
        //try? await cities = imageFetcher.
    }
    
    func startGame() {
        isPlaying = true
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
