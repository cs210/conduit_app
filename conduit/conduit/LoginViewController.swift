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
    
    APIModel.post("/sessions", parameters: ["password": passwordField.text, "email_address": emailField.text]) { (result, error) -> () in
      if (error == nil) {
        var defaults = NSUserDefaults.standardUserDefaults()
        var sessionKey = result!["session"] as! String
        defaults.setValue(sessionKey, forKey: "session")
      } else {
        NSLog("ERROR: Session error")
        
        let alertController = UIAlertController(title: "", message: "There was an error logging into your account. Please try again.",
          preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        return
      }
    }
    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "loggedIn")
    self.dismissViewControllerAnimated(true, completion: {})
  }
  
}