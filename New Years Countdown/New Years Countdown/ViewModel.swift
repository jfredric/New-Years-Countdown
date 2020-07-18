//
//  ViewModel.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/17/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import Foundation

protocol CountDownDelegate {
    func locationDidChange()
}

class ViewModel {
    
    // MARK: Properties
    
    private var newYears:Date?
    private var timeZoneCalendar:Calendar?
    
    var viewDelegate:CountDownDelegate?
    var location:LocationData?
    
    struct CountDownValues: Equatable {
        var days:Int = 0
        var hours: Int = 0
        var minutes: Int = 0
        var seconds: Int = 0
    }
    
    var countDown:CountDownValues {
        // check if a timezone has been set and newYears Date value computed
        if let calendar = timeZoneCalendar, let newYears = newYears  {
            return ViewModel.componentTimeBetween(start: Date(), end: newYears, for: calendar)
        } else {
            return CountDownValues()
        }
    }
    
    // MARK: Instance Functions
    
    func updateLocation(withZipcode zipcode: String) {
        TimezoneAPI.shared.getTimezone(zipcode: zipcode) { [weak self] (locationData) in
            if let locationData = locationData {
                // Save the new location information
                self?.location = locationData
                // Update the countdown values for the timezone
                self?.updateCountDown(withDate: Date(), timezoneIdentifier: locationData.timezone.timezoneIdentifier)
                // Inform viewController that the location has be updated.
                self?.viewDelegate?.locationDidChange()
            }
        }
    }
    
    func updateCountDown(withDate date:Date, timezoneIdentifier timezone: String) {
        if let timezone = TimeZone(identifier: timezone){
            // set the calender to the provided timezone
            timeZoneCalendar = Calendar(identifier: .gregorian)
            timeZoneCalendar!.timeZone = timezone
            
            // get the new years date value for the current date/year
            newYears = getNewYears(date: date)
            if newYears == nil {
                print("[ViewModel] Failed to get new years Date value for given timezone: ",timezone)
            }
            
        } else {
            print("[ViewModel] Failed to get TimeZone value for timezone: ",timezone)
        }
    }
    
    // Returns the Date value representing new years for the year of the date given.
    func getNewYears(date: Date) -> Date? {
        if let calendar = timeZoneCalendar {
            let dateComponents = timeZoneCalendar!.dateComponents([.year], from: date)
            if let year = dateComponents.year {
                return calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1, hour: 0, minute: 0, second: 0))
            }
        }
        
        return nil
    }
    
    // MARK: Helper Functions
    
    class func validate(zipcode:String) -> Bool {
        // Zip codes are 5 digits long and must be all numbers.
        return zipcode.count == 5 && Int(zipcode) != nil
    }
    
    // Takes two dates and gives you the difference in time seperated out into individual time componetnts
    class func componentTimeBetween(start:Date, end:Date, for calendar: Calendar) -> CountDownValues {
        
        let components = calendar.dateComponents([.day,.hour,.minute,.second], from: start, to: end)
        
        return CountDownValues(days: components.day ?? 0, hours: components.hour ?? 0, minutes: components.minute ?? 0, seconds: components.second ?? 0)
    }
    
}

