//
//  LoginViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  
  @IBAction func loginPressed(sender: AnyObject) {
    let params = ["password": passwordField.text, "email_address": emailField.text]
    APIModel.post("sessions/create", parameters: params) { (result, error) -> () in
      if (error == nil) {
        var defaults = NSUserDefaults.standardUserDefaults()
        var sessionKey = result!["session_token"].string!
        defaults.setValue(sessionKey, forKey: "session")
        println("Set token to be: " + sessionKey)
        
        self.dismissViewControllerAnimated(false, completion: {
          if defaults.boolForKey("isNewAccount") {
            // Go to welcome view
            var view = WelcomeViewController()
            self.navigationController?.presentViewController(view, animated: true, completion: nil)
          }
          
        })
      
        // auth with layer...
      } else {
        NSLog("ERROR: Session error")
        
        let alertController = UIAlertController(title: "", message: "There was an error logging into your account. Please try again.",
          preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        return
      }
    }
    
    
    
  }
  
}