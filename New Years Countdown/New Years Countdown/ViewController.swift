//
//  ViewController.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/16/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CountDownDelegate, UITextFieldDelegate {

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
    
    
    // MARK: UIViewContoller Lifecycle and setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Instantiate our view model
        viewModel = ViewModel()
        viewModel.viewDelegate = self
        
        // set up keyboard delegation
        zipcodeTextField.delegate = self
        
        // set up gesture to dismiss keyboard when tapping anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        setupKeyboardToolbar()
        
        // Start the timer to animate the clock
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
    }
    
    // Overide the status bar style to use light text/icons over the dark background.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Updates the clock labels to the most recent values
    @objc func updateTime() {
        daysLabel.text = String(viewModel.countDown.days)
        hoursLabel.text = String(viewModel.countDown.hours)
        minutesLabel.text = String(viewModel.countDown.minutes)
        secondsLabel.text = String(viewModel.countDown.seconds)
    }
    
    // MARK: TextFieldDelegate and Keyboard Setup
    
    func setupKeyboardToolbar() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 35)))
        
        let updateButton = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(processZipcodeInput))
        // Addes space so we can push button to the right side
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, updateButton], animated: false)
        
        // Adds toolbar to the textfields accessory view
        zipcodeTextField.inputAccessoryView = toolbar
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processZipcodeInput()
        return true
    }
    
    // MARK: CountDownDelegate Functions
    
    func locationDidChange() {
        if let locationData = viewModel.location {
            // Ensure the labels hidden before a timezone if set are now shown, and update the city state label for the new location
            DispatchQueue.main.async {
                if let inLabel = self.inLabel {
                    inLabel.isHidden = false
                }
                
                if let locationLabel = self.locationLabel {
                    locationLabel.isHidden = false
                    locationLabel.text = locationData.city + ", " + locationData.state
                }
            }
        }
    }
    
    
    // MARK: Helper Functions
    
    @objc func processZipcodeInput() {
        // Dismiss Keyboard in needed
        self.view.endEditing(true)
        
        // Process user input
        if let zipcode = zipcodeTextField.text {
            if ViewModel.validate(zipcode: zipcode) {
                // if zipcode is valid then update location
                viewModel.updateLocation(withZipcode: zipcode)
            } else {
                // Alert user that there is an issue with the zip.
                let alert = UIAlertController(title: "Invalid Zipcode", message: "Zip codes must be 5 digits long and contain only numbers.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

                self.present(alert, animated: true)
            }
        }
    }

    // MARK: IBAction Functions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        processZipcodeInput()
    }
    


}

