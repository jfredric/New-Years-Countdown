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
    
    // Test that the new years date is correctly returned for a given date.
    func testGetNewYears() throws {
        // Given
        let viewModel = ViewModel()
        viewModel.update(timezoneAbbr: "PDT")
        
        let newYears = calendar.date(from: DateComponents(year: 2021, month: 1, day: 1, hour: 0, minute: 0, second: 0))!
        let newYearsEve = calendar.date(from: DateComponents(year: 2020, month: 12, day: 31, hour: 0, minute: 0, second: 0))!
            
        // When
        let newYearsResult = viewModel.getNewYears(date: newYearsEve)
            
        // Then
        XCTAssertEqual(newYearsResult, newYears)
    }

}
