//
//  CreateAccountController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountController : UIViewController {
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet var passwordField: UITextField!
  @IBOutlet var retypePasswordField: UITextField!
  @IBOutlet weak var retypePasswordErrorLabel: UILabel!
  @IBOutlet var emailField: UITextField!
  @IBOutlet weak var emailErrorLabel: UILabel!
  @IBOutlet weak var phoneNumberField: UITextField!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  var activeTextField : UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    highlightError(firstNameField)
    highlightError(lastNameField)
    highlightError(passwordField)
    highlightError(retypePasswordField)
    retypePasswordErrorLabel.text = ""
    retypePasswordErrorLabel.textColor = StyleColor.getColor(.Error, brightness: .Medium)
    highlightError(emailField)
    emailField.autocorrectionType = UITextAutocorrectionType.No
    emailErrorLabel.text = ""
    emailErrorLabel.textColor = StyleColor.getColor(.Error, brightness: .Medium)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  func keyboardWillShow(sender: NSNotification) {
    var info = sender.userInfo!
    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    self.bottomConstraint.constant = keyboardFrame.size.height
  }
  
  func keyboardWillHide(sender: NSNotification) {
    var info = sender.userInfo!
    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    self.bottomConstraint.constant = 0
  }
  
  @IBAction func cancel(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  
  // Create account
  @IBAction func createAccount(sender: AnyObject) {
    
    if (checkInputs() == false) {
      let alertController = UIAlertController(title: "", message:
        "Please fill in all required inputs.", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
      return
    }
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var deviceToken = defaults.valueForKey("deviceToken") as? String

    // Note: we do not yet have the user id or participantIdentifier since they do not exist on the server.
    var user: User = User(id: nil, firstName: firstNameField.text, lastName: lastNameField.text,
      phoneNumber: phoneNumberField.text, emailAddress: emailField.text, deviceToken: deviceToken,
      pushEnabled: true, participantIdentifier: nil)
    // TODO: bug, push enabled not set to true
    var params = user.present()
    params.updateValue(passwordField.text, forKey: "password")
    
    APIModel.post("users", parameters: params) { (result, error) -> () in
      
      if (error != nil) {
        let alertController = UIAlertController(title: "", message: "There was an error creating your account. Please try again.",
          preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
      
        self.presentViewController(alertController, animated: true, completion: nil)
        return
      } else {
        var user = User(json: result!)
        let encodedUser = NSKeyedArchiver.archivedDataWithRootObject(user)
        defaults.setObject(encodedUser, forKey: "user")
      }
      
      defaults.setBool(true, forKey: "isNewAccount")
      self.navigationController?.popViewControllerAnimated(true)
      
      
      // Success. Now create the Layer participantIdentifier
      var emailAddress: String = result!["email_address"].string!
      var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      
      LayerHelpers.authenticationTokenWithEmailAddress(emailAddress, client: appDelegate.layerClient, completion: { (success, error) -> Void in
        if (error != nil) {
          NSLog("Layer Auth error: \(error)")
          // todo add alert
          return
        }
        // Redirect back to login
        self.navigationController?.popViewControllerAnimated(true)
      })
    
    }
  
  }
  
  // Checks that all req'd fields are filled in and valid. Returns false for 
  // invalid inputs.
  func checkInputs() -> Bool {
    // Required fields: first/last name, password, retype password, email
    
    var error = false
    
    if (emailField.text == "" || !isValidEmail(emailField.text) || !isAvailableEmail(emailField.text)) {
      error = true
    }
    
    if (firstNameField.text == "" || lastNameField.text == "" || passwordField.text == "" || retypePasswordField.text == "") {
      error = true
    }
    
    return !error
  }
  
  
  // Helper functions to highlight and unhighlight text boxes
  func highlightError(field : UITextField) {
    field.layer.cornerRadius = 5
    field.layer.borderWidth = 2
    field.layer.borderColor = StyleColor.getColor(.Error, brightness: .Medium).CGColor
    
  }
  
  func unhighlightError(field : UITextField) {
    field.layer.borderWidth = 0
    field.layer.borderColor = UIColor.clearColor().CGColor
  }

  @IBAction func checkRetypePasswordInput(sender: UITextField) {
    if (sender.text == "") {
      highlightError(sender)
      retypePasswordErrorLabel.text = ""
    } else if (passwordField.text != sender.text) {
      retypePasswordErrorLabel.text = "Passwords do not match."
      sender.text = ""
      highlightError(sender)
//      retypePasswordField.becomeFirstResponder()
    } else {
      unhighlightError(sender)
      retypePasswordErrorLabel.text = ""
    }
  }
  
  
  // Check the format of the email address
  @IBAction func checkEmailInput(sender: UITextField) {
    if (sender.text == "") {
      highlightError(sender)
      emailErrorLabel.text = ""
    } else if (isValidEmail(sender.text) == false) {
      highlightError(sender)
      emailErrorLabel.text = "Please enter a valid e-mail address."
    } else if (isAvailableEmail(sender.text) == false) {
      highlightError(sender)
      emailErrorLabel.text = "There is already an account with that e-mail."
    } else {
      unhighlightError(sender)
      emailErrorLabel.text = ""
    }
  }
  
  // https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
  func isValidEmail(s:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(s)
    
  }
  
  func isAvailableEmail(s : String) -> Bool {
    // TODO(nisha): returns true if the email address is available, false if it's taken
    return true
  }
  
  // Check the input of a required field upon editing completion
  @IBAction func checkInput(sender: UITextField) {
    if (sender.text == "") {
      highlightError(sender)
    } else {
      unhighlightError(sender)
    }
  }


}
