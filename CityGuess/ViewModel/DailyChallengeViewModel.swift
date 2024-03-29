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
    @Published var selectedContinent: CGContinent = .all
    @Published var isShowingNewImage = true

    var roundOptions: [Int] {
        [filterValid(cityImages).count]
    }

    var filteredCityImages: [CityImage] { cityImages }

    @PublishedAppStorage("dailyChallengeUnlockInterval") var unlockTime: TimeInterval = 0
    @PublishedAppStorage("dailyChallengeModeLockInterval") var lockTime: TimeInterval = 0

    var cities: [CGCity] = []
    let cityService: CityService
    let cityFetcher: RedditClient

    let modeTitle: String = "Daily Challenge"
    let gameHeadline: String = "Do you have what it takes to take on the Daily Challenge?"
    let gameDescription: String = "Check in once a day to see some of the latest"
        + " and greatest city photos from around the world. How many can you guess??"

    let startGameButtonText: String = "Start Daily Challenge"

    let notificationDescription: String = """
        Congratulations on completing your first Daily Challenge!\n\n
        - The next challenge will unlock at midnight\n\n
        - You can opt in to notifications to get a reminder when the next challenge unlocks\n\n
        - You can adjust notification settings anytime under your device settings
    """

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
            numberOfRounds = roundOptions[0]
            questions = resetQuestions()
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
                return
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

    func scheduleNotification() {
        guard let secondsUntilNextDay = Date().secondsUntilNextDay else { return }
        let now = Date().timeIntervalSince1970
        lockTime = now
        unlockTime = now + secondsUntilNextDay

        LocalNotificationService.shared.removeDeliveredNotifications()
        LocalNotificationService.shared.requestNotificationPermission()
        LocalNotificationService.shared.scheduleLocalNotification(
            with: "Daily Challenge Mode Unlocked!",
            scheduledIn: secondsUntilNextDay
        )
    }
}

extension DailyChallengeViewModel: Unlockable {

    var unlockText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: unlockTime))

        return "Daily Challenge will unlock at \(formattedDate)"
    }

    var isLocked: Bool {
        unlockTime >= Date().timeIntervalSince1970
    }

    func calculateUnlockProgress() {
        let unlockDate = Date(timeIntervalSince1970: unlockTime)
        let startDate = Date(timeIntervalSince1970: lockTime)
        let duration = unlockDate.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        unlockProgress = elapsed / duration
    }
}
