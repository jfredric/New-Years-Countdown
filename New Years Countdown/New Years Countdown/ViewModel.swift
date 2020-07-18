//
//  ViewModel.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/17/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import Foundation

class ViewModel {
    
    private var newYears:Date?
    private var timeZoneCalendar:Calendar?
    
    struct CountDownValues: Equatable {
        var days:Int = 0
        var hours: Int = 0
        var minutes: Int = 0
        var seconds: Int = 0
    }
    
    var countDown:CountDownValues {
        // check if a timezone has been set and newYears Date value computed
        if let calendar = timeZoneCalendar, let newYears = newYears  {
            return componentTimeBetween(start: Date(), end: newYears, for: calendar)
        } else {
            return CountDownValues()
        }
    }
    
    func update(timezone timezoneString: String) {
        if let timezone = TimeZone(identifier: timezoneString){
            // set the calender to the provided timezone
            timeZoneCalendar = Calendar(identifier: .gregorian)
            timeZoneCalendar!.timeZone = timezone
            
            // get the new years date value for the current date/year
            newYears = getNewYears(date: Date())
            if newYears == nil {
                print("[ViewModel] Failed to get new years Date value for given timezone: ",timezoneString)
            }
            
        } else {
            print("[ViewModel] Failed to get TimeZone value for timezone: ",timezoneString)
        }
    }
    
    // MARK: Helper Functions
    
    // Takes two dates and gives you the difference in time seperated out into individual time componetnts
    func componentTimeBetween(start:Date, end:Date, for calendar: Calendar) -> CountDownValues {
        
        let components = calendar.dateComponents([.day,.hour,.minute,.second], from: start, to: end)
        
        return CountDownValues(days: components.day ?? 0, hours: components.hour ?? 0, minutes: components.minute ?? 0, seconds: components.second ?? 0)
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
}

