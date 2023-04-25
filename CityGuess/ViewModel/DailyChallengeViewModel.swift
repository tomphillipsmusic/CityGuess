//
//  DailyChallengeViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/17/23.
//

import Foundation

@MainActor
class DailyChallengeViewModel: CityGuessViewModel {
    @Published var cityImages = [CityImage]()
    @Published var questions: [Question] = []
    @Published var score = 0
    @Published var currentCityIndex = 0
    @Published var isPlaying = false
    @Published var isCorrect = false
    @Published var priorAnswer = ""
    @Published var numberOfRounds = 5
    @Published var isShowingAnimation: Bool = false

    var cities: [GeoNamesCity] = []
    let cityService: CityService
    let cityFetcher: RedditClient
    let roundLength = 10

    let modeTitle: String = "Daily Challenge"
    let gameHeadline: String = "Do you have what it takes to take on the Daily Challenge?"
    let gameDescription: String = """
        Check in once a day to see some of the latest and greatest city photos from around the world. How many can you guess??
    """
    let startGameButtonText: String = "Start Daily Challenge"

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
