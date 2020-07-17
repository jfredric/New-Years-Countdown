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
    
    var days:Int {
        
        // check if a timezone has been set and newYears Date value computed
        if let calendar = timeZoneCalendar, let newYears = newYears  {
            if let days = calendar.daysBetween(start: Date(), end: newYears) {
                return days
            } else {
                print("[ViewModel] Unknown error calculating days difference")
            }
        }
        
        // if any failures
        return 0
    }
    
    func update(timezoneAbbr: String) {
        if let timeZone = TimeZone(abbreviation: timezoneAbbr) {
            // set the calender to the provided timezone
            timeZoneCalendar = Calendar(identifier: .gregorian)
            timeZoneCalendar!.timeZone = timeZone
            
            // get the new years date value for the current date/year
            newYears = getNewYears(date: Date())
            if newYears == nil {
                print("[ViewModel] Failed to get new years Date value for given timezone abbv: ",timezoneAbbr)
            }
            
        } else {
            print("[ViewModel] Failed to get TimeZone value for timezone abbv: ",timezoneAbbr)
        }
    }
    
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

