//
//  ViewController.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/16/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TimezoneAPI.shared.getTimezone(zipcode: "90293") { (locationData) in
            print(locationData)
        }
    }

    


}

