//
//  SequenceExtensionTests.swift
//  CityGuessTests
//
//  Created by Tom Phillips on 4/27/23.
//

import XCTest
@testable import CityGuess

final class SequenceExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFiltering3UniqueItemsReturns3UniqueItems() {
        let input = [1, 1, 1, 2, 2, 2, 3, 3, 3]

        let expectedResult = [1, 2, 3]
        let actualResult = input.filterUniqueItems({
                _ in true
            }, limit: 3)

        XCTAssertTrue(actualResult == expectedResult.sorted())
    }

    func testFilteringEmptyArrayReturnsEmptyArray() {
        let input: [Int] = []

        let expectedResult: [Int] = []
        let actualResult = input.filterUniqueItems({ _ in
            true
        }, limit: 5)

        XCTAssertTrue(actualResult == expectedResult)
    }

    func testFilteringUniqueItemsFromArrayWithCountLessThanGivenLimitReturnsCorrectCount() {
        let input: [Int] = [1, 1, 2, 2, 3, 3]

        let expectedCount = 3
        let actualResult = input.filterUniqueItems({ _ in
            true
        }, limit: 5)

        XCTAssertTrue(actualResult.count == expectedCount, "\(actualResult)")
    }

    func testFilteringNumbersLessThan0WithLimitof1ReturnsCorrectFilteredValues() {
        let input: [Int] = [-1, -1, -1, 0, 0, 0, 1, 1, 1]

        let expectedOutput = [-1]
        let actualResult = input.filterUniqueItems({ $0 < 0}, limit: 1)

        XCTAssertTrue(actualResult.sorted() == expectedOutput, "\(actualResult)")
    }

}
