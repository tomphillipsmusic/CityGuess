//
//  DailyChallengeViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/17/23.
//

import SwiftUI

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
    @Published var unlockProgress: CGFloat = 0
    @Published var errorMessage: String = "Error"
    @Published var isShowingError: Bool = false

    @PublishedAppStorage("dailyChallengeUnlockInterval") var unlockInterval: TimeInterval = 0

    var cities: [TeleportCity] = []
    let cityService: CityService
    let cityFetcher: RedditClient
    let roundLength = 10

    let modeTitle: String = "Daily Challenge"
    let gameHeadline: String = "Do you have what it takes to take on the Daily Challenge?"
    let gameDescription: String = """
        Check in once a day to see some of the latest and greatest city photos from
        around the world. How many can you guess??
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
            let cityImages = try await cityFetcher.fetchCityImages().shuffled()
            self.cityImages = filterValid(cityImages)
            print("City images count: " + "\(cityImages.count)")
        } catch {
            print(error)
        }
    }

    func fetchCities() async {
        if let cities: [CityModel] = try? cityService.loadCities(),
           !cities.isEmpty {
            self.cities = cities
            return
        } else if let cities = try? await cityFetcher.fetchCities() {
            self.cities = cities
            try? cityService.save(cities)
        }
    }

    private func filterValid(_ cityImages: [CityImage]) -> [CityImage] {
        var result = [CityImage]()

        for image in cityImages {
            for city in cities {
                if image.title.caseInsensitiveContains(city.name) {
                    result.append(image)
                    break
                }
            }
        }

        return result
    }

    func endGame() {
        isPlaying = false
        questions = resetQuestions()
        LocalNotificationService.shared.scheduleLocalNotification(
            with: "Daily Challenge Mode Unlocked!",
            scheduledIn: DateConstants.unlockInterval
        )

        unlockInterval = Date().timeIntervalSince1970 + DateConstants.unlockInterval
    }
}

extension DailyChallengeViewModel: Unlockable {
    var unlockText: String {
        "Daily Challenge will unlock in \(Date(timeIntervalSince1970: unlockInterval).formatted())"
    }

    var isLocked: Bool {
        unlockInterval >= Date().timeIntervalSince1970
    }

    func calculateUnlockProgress() {
        let unlockDate = Date(timeIntervalSince1970: unlockInterval)
        let startDate = unlockDate.addingTimeInterval(-DateConstants.unlockInterval)
        let duration = unlockDate.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        unlockProgress = elapsed / duration
    }
}
