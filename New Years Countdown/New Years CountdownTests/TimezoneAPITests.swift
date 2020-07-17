//
//  TimezoneAPITests.swift
//  New Years CountdownTests
//
//  Created by Joshua Fredrickson on 7/16/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import XCTest
@testable import New_Years_Countdown

class TimezoneAPITests: XCTestCase {
    
    let api = TimezoneAPI.shared

    func testURLReturnsData() throws {
        
        // Given
        let zipCode = "90293"
            
        // When
        let expectation = XCTestExpectation(description: "Requesting timezone for given zipcode")
        api.getTimezone(zipcode: zipCode) { (data) in
            
            // Then
            XCTAssertNotNil(data)
            
            expectation.fulfill()
        }
        
        // We ask the unit test to wait our expectation to finish.
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testLocationDecodes() throws {
        
        // Given
        let zipCode = "90293"
//        let test:Location
            
        // When
        let expectation = XCTestExpectation(description: "Requesting location data for zip code")
        api.getTimezone(zipcode: zipCode) { (location:LocationData?) in
            
            // Then
            if let location = location {
                XCTAssertEqual(location.zipCode, "90293")
                XCTAssertEqual(location.city, "Playa Del Rey")
                XCTAssertEqual(location.state, "CA")
            } else {
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        // We ask the unit test to wait our expectation to finish.
        wait(for: [expectation], timeout: 10.0)
        
    }

}
