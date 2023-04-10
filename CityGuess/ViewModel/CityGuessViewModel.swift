//
//  CityGuessViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

@MainActor
class CityGuessViewModel: ObservableObject {
    @Published var cityImages = [CityImage]()
    @Published var score = 0
    @Published var currentCityIndex = 0
    @Published var isPlaying = false
    @Published var isCorrect = false
    @Published var priorAnswer = ""
    @Published var guess = ""

    
    var cities: [City] = []
    
    let cityService: CityService
    let imageFetcher: CityImageFetching
    
    init(cityService: CityService, imageFetcher: CityImageFetching) {
        self.cityService = cityService
        self.imageFetcher = imageFetcher
        
        Task {
            await fetchCityImages()
        }
        
        cities = cityService.loadCities()
    }
    
    func fetchCityImages() async {
        try? await cityImages = imageFetcher.fetchCities()
    }
    
    func submit() {
        let title = cityImages[currentCityIndex].title
        if title.lowercased().contains(guess.lowercased()) {
            isCorrect = true
            score += 1
        } else {
            isCorrect = false
        }
        
        priorAnswer = title
        currentCityIndex += 1
        guess = ""
    }
}
