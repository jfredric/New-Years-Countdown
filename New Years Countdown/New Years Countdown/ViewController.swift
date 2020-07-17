//
//  ViewController.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/16/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    
    var viewModel:ViewModel!
    
    // Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Instantiate our view model
        viewModel = ViewModel()
        
        // set up keyboard delegation
        zipcodeTextField.delegate = self
        
        // set up gesture to dismiss keyboard when tapping anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        setupKeyboardToolbar()
        
        // Start the timer to animate the clock
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        
    }
    
    // MARK: TextField Setup and Delegate Functions
    
    func setupKeyboardToolbar() {
        
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 35)))
        
        let updateButton = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(updateFromKeyboard))
        // Addes space so we can push button to the right side
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, updateButton], animated: false)
        
        // Adds toolbar to the textfields accessory view
        zipcodeTextField.inputAccessoryView = toolbar
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        updateFromKeyboard()

        return true
    }
    
    
    // MARK: Hepler Functions
    
    // Updates the clock labels to the most resent values
    @objc func updateTime() {
        daysLabel.text = String(viewModel.countDown.days)
        hoursLabel.text = String(viewModel.countDown.hours)
        minutesLabel.text = String(viewModel.countDown.minutes)
        secondsLabel.text = String(viewModel.countDown.seconds)
    }
    
    @objc func updateFromKeyboard() {
        // Dismiss Keyboard
        self.view.endEditing(true)
        
        updateZipcodeFromTextField()
    }
    
    func updateZipcodeFromTextField() {
        if let zipcode = zipcodeTextField.text {
            
            // TODO: validate zipcode and alert for input
            
            TimezoneAPI.shared.getTimezone(zipcode: zipcode) { [weak self] (locationData) in
                DispatchQueue.main.async {
                    if let locationData = locationData {
                        if let inLabel = self?.inLabel {
                            inLabel.isHidden = false
                        }
                        if let locationLabel = self?.locationLabel {
                            locationLabel.isHidden = false
                            locationLabel.text = locationData.city + ", " + locationData.state
                        }
                        if let viewModel = self?.viewModel {
                            viewModel.update(timezoneAbbr: locationData.timezone.timezoneAbbr)
                        }
                    }
                }
            }
        } else {
            // TODO: alert invalid input
        }
    }

    // MARK: Action Functions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        updateZipcodeFromTextField()
    }
    


}

