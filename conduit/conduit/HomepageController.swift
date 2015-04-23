//
//  HomepageController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class HomepageController:UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Authentication probably goes here.
  }

  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  
  // This function is called when "Login" is pressed
  // Currently, it just does a segue to the scanner, but eventually, 
  // authentication will happen here.
  @IBAction func doLogin(sender: AnyObject) {
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggedIn")
    performSegueWithIdentifier("login_to_scanner", sender: self)
  }
}


