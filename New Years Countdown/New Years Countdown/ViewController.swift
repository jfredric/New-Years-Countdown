//
//  ViewController.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/16/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    var viewModel:ViewModel!
    
    // Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel = ViewModel()
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
    }
    
    // MARK: Hepler Functions
    
    // Updates the clock labels to the most resent values
    @objc func updateTime() {
        daysLabel.text = String(viewModel.countDown.days)
        hoursLabel.text = String(viewModel.countDown.hours)
        minutesLabel.text = String(viewModel.countDown.minutes)
        secondsLabel.text = String(viewModel.countDown.seconds)
    }

    // MARK: Action Functions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        TimezoneAPI.shared.getTimezone(zipcode: "90293") { [weak self] (locationData) in
            DispatchQueue.main.async {
                if let locationData = locationData {
                    if let locationLabel = self?.locationLabel {
                        locationLabel.text = locationData.city + ", " + locationData.state
                    }
                    if let viewModel = self?.viewModel {
                        viewModel.update(timezoneAbbr: locationData.timezone.timezoneAbbr)
                    }
                }
            }
        }
    }
    


}

