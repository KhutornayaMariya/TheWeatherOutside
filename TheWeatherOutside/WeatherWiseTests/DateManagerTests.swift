//
//  DateManagerTests.swift
//  WeatherWiseTests
//
//  Created by Mariia Khutornaia on 02.08.23.
//

import XCTest
@testable import WeatherWise

final class DateManagerTests: XCTestCase {

    private let dateTimeInterval = TimeInterval(1677974400)

    func testDateConvert() {
        let date = Date(timeIntervalSince1970: dateTimeInterval)
        let format = "dd/MM"
        let expectedDate = "05/03"

        let convertedDate = DateManager.convert(date, to: "CET", with: format)

        XCTAssertEqual(convertedDate, expectedDate)
    }

    func testDifferentTimeZone() {
        let date = Date(timeIntervalSince1970: dateTimeInterval)
        let format = "dd/MM"
        let expectedDate = "04/03"
        let timeZoneNorthAmerica = "EST"

        let convertedDate = DateManager.convert(date, to: timeZoneNorthAmerica, with: format)

        XCTAssertEqual(convertedDate, expectedDate)
    }
}
