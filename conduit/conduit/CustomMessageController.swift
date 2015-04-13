//
//  CustomMessageController.swift
//  conduit
//
//  Created by Nisha Masharani on 4/1/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class CustomMessageController : UIViewController {
  
  @IBOutlet weak var licenseTextField: UITextField!
  @IBOutlet weak var messageTextField: UITextField!
  var licensePlate : String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if licensePlate == "" {
      licenseTextField.becomeFirstResponder()
    } else {
      messageTextField.becomeFirstResponder()
      licenseTextField.text = licensePlate
    }
    self.view.backgroundColor = StyleColor.getColor(.Grey, brightness: .Light)
  }
  
  // Send a custom message 
  // TODO: add API calls
  @IBAction func sendCustomMessage(sender: AnyObject) {
    // TODO: do we want to trim just whitespace or whitespace AND newlines?
    var message = messageTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    // if we have an empty message, do nothing.
    if message == "" {
      return
    }
    
    // TODO: API calls here.
  }
}