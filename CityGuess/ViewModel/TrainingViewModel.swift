//
//  CityGuessViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

@MainActor
class TrainingViewModel: CityGuessViewModel {
    @Published var cityImages = [CityImage]()
    @Published var questions: [Question] = Array(repeating: Question(text: ""), count: 10)
    @Published var score = 0
    @Published var currentCityIndex = 0
    @Published var isPlaying = false
    @Published var isCorrect = false
    @Published var priorAnswer = ""
    @Published var numberOfRounds = 5
    @Published var isShowingAnimation: Bool = false

    var cities: [TeleportCity] = []
    let cityService: CityService
    let cityFetcher: TeleportApiClient
    let roundLength = 10

    let modeTitle: String = "Training"
    let gameHeadline: String = "Do you have what it takes to be a true City Guesser?"
    let gameDescription: String = """
        Take a spin through our images of famous cities from around the world and
        do your best to guess the name of the city!
        """
    let startGameButtonText: String = "Start Training"

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
