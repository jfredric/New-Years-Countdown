//
//  Calender+MathTests.swift
//  New Years CountdownTests
//
//  Created by Joshua Fredrickson on 7/17/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import XCTest

class Calender_MathTests: XCTestCase {

    let calendar = Calendar(identifier: .gregorian)

    func testDaysBetween() throws {
        // Given
        let today = Date()
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1, hour: 0, minute: 0, second: 0))!
        let endDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 8, hour: 0, minute: 0, second: 0))!
            
        // When
        let zeroDays = calendar.daysBetween(start: today, end: today)
        let sevenDays = calendar.daysBetween(start: startDate, end: endDate)
        let reversedDays = calendar.daysBetween(start: endDate, end: startDate)
            
        // Then
        XCTAssertEqual(zeroDays, 0)
        XCTAssertEqual(sevenDays, 7)
        XCTAssertEqual(reversedDays, -7)
    }

}
