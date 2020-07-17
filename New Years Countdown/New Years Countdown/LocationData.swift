//
//  LocationData.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/16/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import Foundation

class LocationData: Decodable {
    var zipCode: String
    var city: String
    var state: String
    
    class Timezone: Decodable {
        var timezoneIdentifier: String
        var timezoneAbbr: String
        var utcOffsetSec: Int
        var isDst: String
        
    }
    var timezone:Timezone
}

