//
//  changePasswordView.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class changePasswordView : UIViewController {
  
  @IBOutlet var oldPasswordField: UITextField!
  @IBOutlet var newPasswordField: UITextField!
  @IBOutlet var confirmPasswordField: UITextField!
  
  @IBAction func savePassword(sender: AnyObject) {
    var error = false
    if (oldPasswordField.text != "password") {
      error = true
      var alert = UIAlertController(title: "Error", message: "Incorrect Password!", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
    }
    if (newPasswordField.text != confirmPasswordField.text) {
      var alert = UIAlertController(title: "Error", message: "Passwords don't match!", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
      error = true
    }
    
    if (!error) {
      var alert = UIAlertController(title: "Success", message: "Password changed!", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
  
}
