//
//  Validator.swift
//  conduit
//
//  Created by Nisha Masharani on 5/6/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation

class Validator {
  // https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
  class func isValidEmail(s:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(s)
    
  }
  
  class func isValidPhoneNumber(s : String) -> Bool {
    let PHONE_REGEX = "^\\(?\\d{3}\\)?-?\\s?\\d{3}-?\\d{4}$"
    
    let phoneTest = NSPredicate(format:"SELF MATCHES %@", PHONE_REGEX)
    return phoneTest.evaluateWithObject(s)
  }
  
  // Helper functions to highlight and unhighlight text boxes
  class func highlightError(field : UITextField) {
    field.layer.cornerRadius = 5
    field.layer.borderWidth = 2
    field.layer.borderColor = StyleColor.getColor(.Error, brightness: .Medium).CGColor
    
  }
  
  class func unhighlightError(field : UITextField) {
    field.layer.borderWidth = 0
    field.layer.borderColor = UIColor.clearColor().CGColor
  }
}

class AlertHelper {

}