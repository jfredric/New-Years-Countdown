//
//  ViewController.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/16/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var locationLabel: UILabel!
    
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    // MARK: Action Functions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        TimezoneAPI.shared.getTimezone(zipcode: "90293") { [weak self] (locationData) in
            DispatchQueue.main.async {
                if let locationData = locationData {
                    if let locationLabel = self?.locationLabel {
                        locationLabel.text = locationData.city + ", " + locationData.state
                    }
                }
            }
        }
    }
    


}

