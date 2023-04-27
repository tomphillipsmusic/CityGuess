//
//  CityGuessTests.swift
//  CityGuessTests
//
//  Created by Tom Phillips on 4/26/23.
//

import XCTest
@testable import CityGuess

final class StringExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLowercasedWordsThatStartTheSameReturnsTrue() throws {
        let firstWord = "testtest"
        let secondWord = "test"
        XCTAssertTrue(firstWord.caseInsensitiveStarts(with: secondWord))
    }

    func testLowercasedWordsThatEndTheSameReturnsFalse() throws {
        let firstWord = "BestTest"
        let secondWord = "WorstTest"
        XCTAssertFalse(firstWord.caseInsensitiveStarts(with: secondWord))
    }

    func testUppercasedWordThatEndsTheSameAsLowercasedWordReturnsFalse() throws {
        let firstWord = "BESTTEST"
        let secondWord = "worsttest"
        XCTAssertFalse(firstWord.caseInsensitiveStarts(with: secondWord))
    }

    func testUppercasedWordThatStartsTheSameAsLowercasedWordReturnsTrue() throws {
        let firstWord = "testtest"
        let secondWord = "TEST"
        XCTAssertTrue(firstWord.caseInsensitiveStarts(with: secondWord))
    }

    func testLowercasedWordsThatContainsTheStringReturnsTrue() throws {
        let firstWord = "standardized tests are hard"
        let secondWord = "test"
        XCTAssertTrue(firstWord.caseInsensitiveContains(secondWord))
    }

    func testLowercasedWordsThatDoesNotContainTheStringReturnsFalse() throws {
        let firstWord = "Best"
        let secondWord = "Worst"
        XCTAssertFalse(firstWord.caseInsensitiveContains(secondWord))
    }

    func testUppercasedWordThatContainsTheLowercasedStringReturnsTrue() throws {
        let firstWord = "WORSTESTIMATE"
        let secondWord = "test"
        XCTAssertTrue(firstWord.caseInsensitiveContains(secondWord))
    }

    func testLowercasedWordThatContainsTheUppercasedStringReturnsTrue() throws {
        let firstWord = "worstestimate"
        let secondWord = "TEST"
        XCTAssertTrue(firstWord.caseInsensitiveContains(secondWord))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
