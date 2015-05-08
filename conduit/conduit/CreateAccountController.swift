//
//  CreateAccountController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountController : UIViewController, UITextFieldDelegate {
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet var passwordField: UITextField!
  @IBOutlet var retypePasswordField: UITextField!
  @IBOutlet weak var retypePasswordErrorLabel: UILabel!
  @IBOutlet var emailField: UITextField!
  @IBOutlet weak var emailErrorLabel: UILabel!
  @IBOutlet weak var phoneNumberField: UITextField!
  @IBOutlet weak var phoneNumberErrorLabel: UILabel!
  
  var textfields:[UITextField] = []
  var activeTextField : UITextField!
  var scrollFlag: Bool = true
  @IBOutlet weak var createAcctButton: UIButton!
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("CreateAccount")
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    self.navigationController?.navigationBar.translucent = true
    self.createAcctButton.backgroundColor = nil
    StyleHelpers.setButtonFont(createAcctButton)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Validator.highlightError(firstNameField)
    Validator.highlightError(lastNameField)
    Validator.highlightError(passwordField)
    Validator.highlightError(retypePasswordField)
    retypePasswordErrorLabel.text = ""
    retypePasswordErrorLabel.textColor = StyleColor.getColor(.Error, brightness: .Medium)
    Validator.highlightError(emailField)
    emailField.autocorrectionType = UITextAutocorrectionType.No
    emailErrorLabel.text = ""
    emailErrorLabel.textColor = StyleColor.getColor(.Error, brightness: .Medium)
    Validator.highlightError(phoneNumberField)
    phoneNumberErrorLabel.text = ""
    phoneNumberErrorLabel.textColor = StyleColor.getColor(.Error, brightness: .Medium)
    
    textfields.append(firstNameField)
    textfields.append(lastNameField)
    textfields.append(passwordField)
    textfields.append(retypePasswordField)
    textfields.append(emailField)
    textfields.append(phoneNumberField)
    
    for tf in textfields {
      tf.delegate = self
    }
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

  }
  
  func keyboardWillShow(notification: NSNotification) {
    var info = notification.userInfo as! [String: NSObject]
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
      println(scrollFlag)
      if (scrollFlag) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height), animated: true)
      }
    }
    
  }

  
  func keyboardWillHide(notification: NSNotification) {
    self.scrollView.setContentOffset(CGPointZero, animated: true)
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    textField.delegate = self
  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if (textField == textfields[4] || textField == textfields[5] || textField == textfields[3]) {
      scrollFlag = true
    } else {
      scrollFlag = false
    }
    return true
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    var foundField = false
    for (i, tf) in enumerate(textfields) {
      if (textField == tf && i < textfields.count - 1) {
        textfields[i+1].becomeFirstResponder()
        foundField = true
      }
    }
    if (!foundField) {
      // submit form
      createAccount(textField)
    }
    return false
  }
  
  @IBAction func cancel(sender: AnyObject) {
    self.doneCreatingAccount()
  }
  
  func doneCreatingAccount() {
    if let n = self.navigationController?.viewControllers?.count {
      if let previousViewController = self.navigationController?.viewControllers[n-2] as! LoginViewController? {
        previousViewController.emailField.text = ""
        previousViewController.passwordField.text = ""
      }
    }
    navigationController?.popViewControllerAnimated(true)
  }
  
  // Create account
  @IBAction func createAccount(sender: AnyObject) {
    AnalyticsHelper.trackButtonPress("create_account")
    
    if (checkInputs() == false) {
      AnalyticsHelper.trackEvent("user_error", label: "bad_create_account")
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
      pushEnabled: true)
    // TODO: bug, push enabled not set to true
    var params = user.present()
    params.updateValue(passwordField.text, forKey: "password")
    
    APIModel.post("users", parameters: params) { (result, error) -> () in
      
      if (error != nil) {
        let alertController = UIAlertController(title: "", message: "There was an error creating your account. Check to see if your email address or phone number is associated with another account and please try again.",
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
      self.doneCreatingAccount()
    
    }
  
  }
  
  // Checks that all req'd fields are filled in and valid. Returns false for 
  // invalid inputs.
  func checkInputs() -> Bool {
    // Required fields: first/last name, password, retype password, email
    
    var error = false
    
    if (emailField.text == "" || !Validator.isValidEmail(emailField.text) || !isAvailableEmail(emailField.text)) {
      error = true
    }
    
    if (firstNameField.text == "" || lastNameField.text == "" ||
      passwordField.text == "" || retypePasswordField.text == "" ||
      phoneNumberField.text == "") {
      error = true
    }
    
    return !error
  }
  

  @IBAction func checkRetypePasswordInput(sender: UITextField) {
    if (sender.text == "") {
      Validator.highlightError(sender)
      retypePasswordErrorLabel.text = ""
    } else if (passwordField.text != sender.text) {
      retypePasswordErrorLabel.text = "Passwords do not match."
      sender.text = ""
      Validator.highlightError(sender)
//      retypePasswordField.becomeFirstResponder()
    } else {
      Validator.unhighlightError(sender)
      retypePasswordErrorLabel.text = ""
    }
  }
  
  
  // Check the format of the email address
  @IBAction func checkEmailInput(sender: UITextField) {
    if (sender.text == "") {
      Validator.highlightError(sender)
      emailErrorLabel.text = ""
    } else if (Validator.isValidEmail(sender.text) == false) {
      Validator.highlightError(sender)
      emailErrorLabel.text = "Please enter a valid e-mail address."
    } else if (isAvailableEmail(sender.text) == false) {
      Validator.highlightError(sender)
      emailErrorLabel.text = "There is already an account with that e-mail."
    } else {
      Validator.unhighlightError(sender)
      emailErrorLabel.text = ""
    }
  }
  
  func isAvailableEmail(s : String) -> Bool {
    // TODO(nisha): returns true if the email address is available, false if it's taken
    return true
  }
  
  // Check the input of a required field upon editing completion
  @IBAction func checkInput(sender: UITextField) {
    if (sender.text == "") {
      Validator.highlightError(sender)
    } else {
      Validator.unhighlightError(sender)
    }
  }
  
  @IBAction func checkPhoneNumberInput(sender : UITextField) {
    if sender.text == "" {
      Validator.highlightError(sender)
      phoneNumberErrorLabel.text = ""
    } else if Validator.isValidPhoneNumber(sender.text) == false {
      Validator.highlightError(sender)
      phoneNumberErrorLabel.text = "Please enter a valid phone number."
    } else if isAvailablePhoneNumber(sender.text) == false {
      Validator.highlightError(sender)
      phoneNumberErrorLabel.text = "There is already an account with that phone number."
    } else {
      Validator.unhighlightError(sender)
      phoneNumberErrorLabel.text = ""
    }
  }

  
  func isAvailablePhoneNumber(s : String) -> Bool {
    // TODO(nisha): returns true if the phone number is available, false if it's taken

    return true
  }


}
