//
//  Calendar+Math.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/17/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import Foundation

extension Calendar {
    
    func daysBetween(start:Date, end:Date) -> Int? {
        let components = self.dateComponents([.day], from: start, to: end)
        
        if let days = components.day {
            return days
        }
        
        return nil
    }
}
