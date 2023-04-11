//
//  CityGuessViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

@MainActor
class CityGuessViewModel: ObservableObject {
    @Published private(set) var cityImages = [CityImage]()
    @Published private(set) var score = 0
    @Published private(set) var currentCityIndex = 0
    @Published private(set) var isPlaying = false
    @Published private(set) var isCorrect = false
    @Published private(set) var priorAnswer = ""
    
    private var cities: [City] = []
    
    let cityService: CityService
    let imageFetcher: CityImageFetching
    
    init(cityService: CityService = JsonCityService(), imageFetcher: CityImageFetching = RedditClient()) {
        self.cityService = cityService
        self.imageFetcher = imageFetcher
        
        Task {
            await fetchCityImages()
        }
        
        cities = cityService.loadCities()
    }
        
    func fetchCityImages() async {
        try? await cityImages = imageFetcher.fetchCityImages()
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

    func autofillSuggestions(for guess: String) -> [City] {
        guard !guess.isEmpty else { return [] }
        let numberOfSuggestions = 5
        return cities.filter({ $0.name.starts(with: guess)}, limit: numberOfSuggestions)
    }
}
