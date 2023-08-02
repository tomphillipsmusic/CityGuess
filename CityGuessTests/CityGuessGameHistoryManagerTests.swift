//
//  CityGuessGameHistoryManagerTests.swift
//  CityGuessTests
//
//  Created by Tom Phillips on 6/20/23.
//

import XCTest
@testable import CityGuess

class MockGameHistoryService: ReadWrite {
    var gameHistory: CityGuessHistoryDictionary = [:]

    func read<T>(from filename: String) throws -> T where T: Decodable {
        if let gameHistory = gameHistory as? T {
            return gameHistory
        }

        throw HttpError.unableToComplete
    }

    func write<T>(_ data: T, to filename: String) where T: Encodable {
        if let dataToSave = data as? CityGuessHistoryDictionary {
            gameHistory = dataToSave
        }
    }

    enum MockHistoryError: Error {
        case couldNotRead, couldNotWrite
    }
}

final class CityGuessGameHistoryManagerTests: XCTestCase {
    let mockCityImage = CityImage(title: "New Detroit", url: "www.newdetroit.com/picture.png")
    var historyManager = CityGuessGameHistoryManager(historyService: MockGameHistoryService())
    
    var mockCityName: String { mockCityImage.title }

    override func setUpWithError() throws {
        historyManager = CityGuessGameHistoryManager(historyService: MockGameHistoryService())
    }

    func testThereIsNoDefaultHistoryIfThereIsNothingToReadInFromTheHistoryService() {
        XCTAssertTrue(historyManager.guessHistory.count == 0)
    }

    func testThatHistoryManagerReadsHistoryOnCreationIfThereIsPastHistorySaved() {
        // Arrange
        let mockService = MockGameHistoryService()
        historyManager = CityGuessGameHistoryManager(historyService: mockService)
        historyManager.updateHistory(forImage: mockCityImage, with: .right)

        // Act
        historyManager = CityGuessGameHistoryManager(historyService: mockService)

        // Assert
        XCTAssertTrue(historyManager.guessHistory[mockCityName] != nil)
    }

    func testThatUpdatingHistoryWithCorrectQuestionStateCorrectlyUpdatesHistory() {
        // Arrange
        let mockHistory = CityGuessHistory(name: mockCityName, urlString: "www.updatedimage.com")
        historyManager.update(mockCityName, with: mockHistory)

        // Act
        historyManager.updateHistory(forImage: mockCityImage, with: .right)

        // Assert
        let actualStatus = historyManager.guessHistory[mockCityName]?.guessStatus
        XCTAssertEqual(actualStatus, .right)
    }

    func testThatUpdatingPreviouslyCorrectHistoryWithIncorrectAnswerStllShowsCorrect() {
        // Arrange
        let mockHistory = CityGuessHistory(name: mockCityName, guessStatus: .right, urlString: "www.updatedhistory.com")
        historyManager.update(mockCityName, with: mockHistory)

        // Act
        historyManager.updateHistory(forImage: mockCityImage, with: .wrong)

        // Assert
        let actualStatus = historyManager.guessHistory[mockCityName]?.guessStatus
        XCTAssertEqual(actualStatus, .right)
    }

    func testThatSaveHistoryMakesHistoryDataPersist() {
        // Arrange
        let mockService = MockGameHistoryService()
        let mockHistory = CityGuessHistory(name: mockCityName, urlString: "www.updatedhistory.com")
        historyManager = CityGuessGameHistoryManager(historyService: mockService)
        historyManager.update(mockCityName, with: mockHistory)
        // Act
        historyManager.saveHistory()
        historyManager = CityGuessGameHistoryManager(historyService: mockService)

        // Assert
        let persistedCity = historyManager.guessHistory[mockCityName]
        XCTAssertEqual(persistedCity?.name, mockHistory.name)
    }

    func testThatLoadHistoryReturnsPersistedHistory() {
        // Arrange
        let mockService = MockGameHistoryService()
        let mockHistory = CityGuessHistory(name: mockCityName, urlString: "www.updatedhistory.com")
        historyManager = CityGuessGameHistoryManager(historyService: mockService)
        historyManager.update(mockCityName, with: mockHistory)
        historyManager.saveHistory()
        let savedHistory = historyManager.guessHistory

        // Act
        historyManager = CityGuessGameHistoryManager(historyService: mockService)
        let loadedCities = try? historyManager.loadHistory()

        // Assert
        XCTAssertEqual(loadedCities?.count, savedHistory.count)
    }

    func testTotalCitiesSeenReflectsTotalNumberOfCitiesSeen() {
        // Arrange
        historyManager.update(CityGuessHistory.testData)

        // Act
        let totalCitiesSeen = historyManager.totalCitiesSeen

        // Assert
        let expectedCitiesSeen = CityGuessHistory.testData.count
        XCTAssertEqual(totalCitiesSeen, expectedCitiesSeen)
    }

    func testCitiesGuessedCorrectlyReflectsTotalNumberOfCitiesSeen() {
        // Arrange
        historyManager.update(CityGuessHistory.testData)

        // Act
        let totalCitiesSeen = historyManager.citiesGuessedCorrectly

        // Assert
        let expectedCitiesSeen = CityGuessHistory.testData.filter { $0.value.guessStatus == .right }.count
        XCTAssertEqual(totalCitiesSeen, expectedCitiesSeen)
    }
}
