//
//  CityGuessViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import Foundation

private let defaultNumberOfRounds = 5

@MainActor
class TrainingViewModel: CityGuessViewModel {
    @Published var cityImages = [CityImage]()
    @Published var questions: [Question] = Array(repeating: Question(text: ""), count: defaultNumberOfRounds)
    @Published var score = 0
    @Published var currentCityIndex = 0
    @Published var isPlaying = false
    @Published var isCorrect = false
    @Published var priorAnswer = ""
    @Published var numberOfRounds = defaultNumberOfRounds
    @Published var isShowingAnimation: Bool = false
    @Published var errorMessage: String = "Error"
    @Published var isShowingError: Bool = false

    var cities: [TeleportCity] = []
    let cityService: CityService
    let cityFetcher: TeleportApiClient

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
            errorMessage = "Error loading city images. Please try again later."
            isShowingError = true
        }
    }

    func fetchCities() async {
        do {
            if let cities: [CityModel] = try? cityService.loadCities(),
               !cities.isEmpty {
                self.cities = cities
            } else {
                let cities = try await cityFetcher.fetchCities()
                self.cities = cities
                try? cityService.save(cities)
            }
        } catch {
            errorMessage = "Error loading city data. Please try again later."
            isShowingError = true
        }
    }
}
