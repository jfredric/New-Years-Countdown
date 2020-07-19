//
//  KeyboardNotifier.swift
//  New Years Countdown
//
//  Created by Joshua Fredrickson on 7/18/20.
//  Copyright © 2020 Joshua Fredrickson. All rights reserved.
//

import UIKit

protocol KeyboardNotifierDelegate {
    
    func keyboardWillShow(withduration duration:TimeInterval, animationOptions: UIView.AnimationOptions, height:CGFloat)
    
    func keyboardWillDismiss(withduration duration:TimeInterval, animationOptions: UIView.AnimationOptions)
    
}

// Derived from suggestions here: https://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift

class KeyboardNotifier {
    
    var delegate:KeyboardNotifierDelegate?
    
    init() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        // Unwrap the userInfo, and check that there is a delegate. If no delegate no need to do anything.
        if let userInfo = notification.userInfo, let delegate = delegate {
            // Get the final frame position of the keyboard
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            
            // duration of keyboard animation
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            
            // The particular animation options being used by the keyboard.
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            // Determine if the keyboard is showing or dismissing based on final position
            if endFrameY >= UIScreen.main.bounds.size.height {
                delegate.keyboardWillDismiss(withduration: duration, animationOptions: animationCurve)
            } else {
                delegate.keyboardWillShow(withduration: duration, animationOptions: animationCurve, height: endFrame?.size.height ?? 0.0)
            }
        }
    }
}
