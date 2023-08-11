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
    @Published var selectedContinent: CGContinent = .all
    @Published var filteredCityImages: [CityImage] = []

    var cities: [CGCity] = []
    let cityService: CityService
    let cityFetcher: TeleportApiClient

    let modeTitle: String = "Training"
    let gameHeadline: String = "Do you have what it takes to be a true City Guesser?"
    let gameDescription: String = "Take a spin through our images of famous cities from around the world"
        + "and do your best to guess the name of the city!"
    let startGameButtonText: String = "Start Training"

    var roundOptions: [Int] {
        var roundOptions: [Int] = []

        let imageCount = filteredCityImages.count

        if imageCount >= 5 {
            roundOptions.append(5)
        }

        if imageCount >= 10 {
            roundOptions.append(10)
        }

        if imageCount >= 25 {
            roundOptions.append(25)
        }

        return roundOptions
    }

    required init(cityService: CityService = LocalCityService(), cityFetcher: TeleportApiClient = TeleportApiClient()) {
        self.cityService = cityService
        self.cityFetcher = cityFetcher

        Task {
            await fetchCities()
            await fetchCityImages()
            filteredCityImages = cityImages
        }
    }

    func fetchCityImages() async {
        do {
            if let cityImages = try? cityService.loadImages() {
                self.cityImages = cityImages.shuffled()
            } else {
                if let defaultImages = try? Bundle.main.decode([CityImage].self, from: "InitialCityImages.json") {
                    cityImages = defaultImages
                    cityService.save(cityImages)
                }
                cityImages = try await cityFetcher.fetchCityImages().shuffled()
                cityService.save(cityImages)
            }
        } catch {
            errorMessage = "Error loading city images. Please try again later."
            isShowingError = true
        }
    }

    func fetchCities() async {
        do {
            if let cities: [CGCity] = try? cityService.loadCities(),
               !cities.isEmpty {
                self.cities = cities
            } else {
                if let defaultImages = try? Bundle.main.decode([CGCity].self, from: "InitialCities.json") {
                    cities = defaultImages
                    try? cityService.save(cities)
                }
                let cities: [CGCity] = try await cityFetcher.fetchCities()
                self.cities = cities

                cities.forEach { print("Printing CGCITY: \($0)")}
                try? cityService.save(cities)
            }
        } catch {
            errorMessage = "Error loading city data. Please try again later."
            isShowingError = true
        }
    }

    func filterCityImages() {
        if selectedContinent == .all {
            filteredCityImages = cityImages.shuffled()
        }

        let filteredImages = cityImages.filter { image in

            let city = cities.first { $0.name == image.title }

            return city?.continent == selectedContinent ? true : false
        }

        filteredCityImages = filteredImages.shuffled()

        if filteredImages.count >= defaultNumberOfRounds {
            numberOfRounds = roundOptions[0]
        }
    }
    
    func startGame(with numberOfRounds: Int) {
        self.numberOfRounds = numberOfRounds
        isPlaying = true
        score = 0
        cityImages.shuffle()
        filteredCityImages.shuffle()
        priorAnswer = ""
        currentCityIndex = 0
        questions = resetQuestions()
    }
}
