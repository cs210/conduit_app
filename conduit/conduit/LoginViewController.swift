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
  
  @IBAction func cancel(sender: AnyObject) {
      navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func loginPressed(sender: AnyObject) {
    // Do login
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggedIn")
    self.dismissViewControllerAnimated(true, completion: {})
  }
  
}