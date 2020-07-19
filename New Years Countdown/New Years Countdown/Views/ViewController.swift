//
//  ViewController.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/16/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KeyboardNotifierDelegate, CountDownDelegate, UITextFieldDelegate {
    
    

    // MARK: Properties
    
    var viewModel:ViewModel!
    var keyboardNotifier:KeyboardNotifier!
    var inputBottomConstant: CGFloat!
    
    // Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputContainerBottomConstraint: NSLayoutConstraint!
    
    // MARK: UIViewContoller Lifecycle and setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Instantiate our view model
        viewModel = ViewModel()
        viewModel.viewDelegate = self
        
        // Set the initial label for location to include the time zone abbreviation
        if let timeZoneAbbr = Calendar(identifier: .gregorian).timeZone.abbreviation() {
            locationLabel.text = "Current Timezone (" + timeZoneAbbr + ")"
        }
        
        // set up keyboard delegation
        zipcodeTextField.delegate = self
        keyboardNotifier = KeyboardNotifier()
        keyboardNotifier.delegate = self
        
        // Save the current bottom constraint value for the inputContainerView
        inputBottomConstant = inputContainerBottomConstraint.constant
        
        // set up gesture to dismiss keyboard when tapping anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Start the timer to animate the clock
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
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
    
    // MARK: KeyboardNotifier Delegate
    
    func keyboardWillShow(withduration duration: TimeInterval, animationOptions: UIView.AnimationOptions, height: CGFloat) {
        
        self.inputContainerBottomConstraint.constant = height
        self.inputContainerView.backgroundColor = UIColor.lightGray
        self.updateButton.isHidden = false
        
        UIView.animate(withDuration: duration,
           delay: TimeInterval(0),
           options: animationOptions,
           animations: { self.view.layoutIfNeeded() },
           completion: nil)
    }
    
    func keyboardWillDismiss(withduration duration: TimeInterval, animationOptions: UIView.AnimationOptions) {
        
        self.inputContainerBottomConstraint.constant = self.inputBottomConstant
        self.inputContainerView.backgroundColor = UIColor.clear
        self.updateButton.isHidden = true
        
        UIView.animate(withDuration: duration,
        delay: TimeInterval(0),
        options: animationOptions,
        animations: { self.view.layoutIfNeeded() },
        completion: nil)
    }
    
    // MARK: TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processZipcodeInput()
        return true
    }
    
    // MARK: CountDownDelegate Functions
    
    func networkErrorOccured(error: Error) {
        DispatchQueue.main.async {
            // Alert user that there was an issue connecting to the server.
            let alert = UIAlertController(title: "Network Issue", message: "Could not connect to server. Check network connection.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
    }
    
    func locationDidChange() {
        if let locationData = viewModel.location {
            DispatchQueue.main.async {
                
                // update the location label for the new city state
                if let locationLabel = self.locationLabel {
                    locationLabel.text = locationData.city + ", " + locationData.state
                }
                
                // clear the textfield
                self.zipcodeTextField.text = ""
            }
        }
    }
    
    // MARK: Helper Functions
    
    @objc func processZipcodeInput() {
        // Dismiss Keyboard
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

