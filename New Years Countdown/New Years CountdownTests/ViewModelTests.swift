//
//  ViewModelTests.swift
//  New Years CountdownTests
//
//  Created by Joshua Fredrickson on 7/17/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import XCTest
@testable import New_Years_Countdown

class ViewModelTests: XCTestCase {

    let calendar = Calendar(identifier: .gregorian)
    var viewModel:ViewModel!
    
    override func setUp() {
        viewModel = ViewModel()
        viewModel.update(timezoneAbbr: "PDT")
    }
    
    // Test that time values between two dates for each component are calculated corrected
    func testComponentTimeBetween() throws {
        // Given
        let today = Date()
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1, hour: 0, minute: 30, second: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 8, hour: 0, minute: 0, second: 0))!
            
        // When
        let sameDate = viewModel.componentTimeBetween(start: today, end: today, for: calendar)
        let sevenDays = viewModel.componentTimeBetween(start: startDate, end: endDate, for: calendar)
        let reversedDays = viewModel.componentTimeBetween(start: endDate, end: startDate, for: calendar)
            
        // Then
        XCTAssertEqual(sameDate, ViewModel.CountDownValues())
        XCTAssertEqual(sevenDays, ViewModel.CountDownValues(days: 7, hours: 0, minutes: 30, seconds: 59))
        XCTAssertEqual(reversedDays, ViewModel.CountDownValues(days: -7, hours: 0, minutes: -30, seconds: -59))
    }
    
    // Test that the new years date is correctly returned for a given date.
    func testGetNewYears() throws {
        // Given
        let newYears = calendar.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 0, minute: 0, second: 0))!
        let newYearsEve = calendar.date(from: DateComponents(year: 2020, month: 12, day: 31, hour: 0, minute: 0, second: 0))!
            
        // When
        let newYearsResult = viewModel.getNewYears(date: newYearsEve)
            
        // Then
        XCTAssertEqual(newYearsResult, newYears)
    }

}
