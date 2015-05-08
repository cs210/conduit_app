//
//  ChangePasswordView.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit
import GoogleAnalytics_iOS_SDK

class ChangePasswordView : GAITrackedViewController {
  
  @IBOutlet var newPasswordField: UITextField!
  @IBOutlet var confirmPasswordField: UITextField!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.screenName = "ChangePassword"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  @IBAction func savePassword(sender: AnyObject) {
    var error = false
    if (newPasswordField.text != confirmPasswordField.text) {
      var alert = UIAlertController(title: "Error", message: "Passwords don't match!", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
      error = true
    } else {
      var user = User.getUserFromDefaults()
      if user == nil {
        return
      }
  
//      user?.password = newPasswordField.text
//      user!.update { (result, error) -> () in
//        let alertController = UIAlertController(title: "", message:
//          "Your password has been updated!", preferredStyle: UIAlertControllerStyle.Alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
//  
//        self.presentViewController(alertController, animated: true, completion: nil)
//      }
    }
  }
 
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "notify_changed_password_segue") {
      println("notifying!")
      self.navigationController?.viewControllers.removeLast()
    }
  }
  
}
