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
    private let imageFetcher: CityImageFetching
    
    init(cityService: CityService = LocalCityService(), imageFetcher: CityImageFetching = RedditClient()) {
        self.cityService = cityService
        self.imageFetcher = imageFetcher
        
        Task {
            //await fetchCityImages()
            
            if let cityFetcher = imageFetcher as? any CityFetching {
                if let cities = try? await cityFetcher.fetchCities() as? [T] {
                    self.cities = cities
                    try? cityService.save(cities)
                    print(cities.count)
                    
                    do {
                        cityImages = try await imageFetcher.fetchCityImages()
                        print(cityImages.count)
                    } catch {
                        print(error)
                    }
                }
            }
            
//            do {
//                cities = try cityService.loadCities()
//            } catch {
//                print(error)
//            }
        }
        
    }
        
    func fetchCityImages() async {
        try? await cityImages = imageFetcher.fetchCityImages()
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
