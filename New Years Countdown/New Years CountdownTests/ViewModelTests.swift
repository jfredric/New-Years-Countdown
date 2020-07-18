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
    
    // Test that time values between two dates for each component are calculated corrected
    func testComponentTimeBetween() throws {
        // Given
        let today = Date()
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1, hour: 0, minute: 30, second: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 8, hour: 0, minute: 0, second: 0))!
            
        // When
        let sameDate = ViewModel.componentTimeBetween(start: today, end: today, for: calendar)
        let sevenDays = ViewModel.componentTimeBetween(start: startDate, end: endDate, for: calendar)
        let reversedDays = ViewModel.componentTimeBetween(start: endDate, end: startDate, for: calendar)
            
        // Then
        XCTAssertEqual(sameDate, CountDownData())
        XCTAssertEqual(sevenDays, CountDownData(days: 6, hours: 23, minutes: 29, seconds: 59))
        XCTAssertEqual(reversedDays, CountDownData(days: -6, hours: -23, minutes: -29, seconds: -59))
    }
    
    // Test that the new years date is correctly returned for a given date.
    func testGetNewYears() throws {
        // Given
        let viewModel = ViewModel()
        viewModel.updateCountDown(withDate: Date(), timezoneIdentifier: "America/Los_Angeles")
        
        let newYears = calendar.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 0, minute: 0, second: 0))!
        let newYearsEve = calendar.date(from: DateComponents(year: 2020, month: 12, day: 31, hour: 0, minute: 0, second: 0))!
            
        // When
        let newYearsResult = viewModel.getNewYears(date: newYearsEve)
            
        // Then
        XCTAssertEqual(newYearsResult, newYears)
    }
    
    func testValidateInput() throws {
        // Given
        let valid = "90293"
        let short = "902"
        let long = "902930"
        let nonNumber = "902B3"
        let decimalNumber = "902.3"
        
        // When & Then
        XCTAssertTrue(ViewModel.validate(zipcode: valid))
        XCTAssertFalse(ViewModel.validate(zipcode: short))
        XCTAssertFalse(ViewModel.validate(zipcode: long))
        XCTAssertFalse(ViewModel.validate(zipcode: nonNumber))
        XCTAssertFalse(ViewModel.validate(zipcode: decimalNumber))
    }

}
