//
//  ChangePasswordView.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordView : UIViewController {
  
  @IBOutlet var newPasswordField: UITextField!
  @IBOutlet var confirmPasswordField: UITextField!
  
  @IBAction func savePassword(sender: AnyObject) {
    var error = false
    if (newPasswordField.text != confirmPasswordField.text) {
      var alert = UIAlertController(title: "Error", message: "Passwords don't match!", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
      error = true
    } else {
        println("weinhere")
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "notify_changed_password_segue") {
      println("notifying!")
      self.navigationController?.viewControllers.removeLast()
    }
  }
  
}
