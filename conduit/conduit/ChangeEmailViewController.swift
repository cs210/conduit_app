//
//  ChangeEmailViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/29/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController {
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ChangeEmail")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailTextField.becomeFirstResponder()
    Validator.highlightError(emailTextField)
    // Do any additional setup after loading the view.
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    emailTextField.autocorrectionType = UITextAutocorrectionType.No
  }
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    var info = notification.userInfo as! [String: NSObject]
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
      self.bottomConstraint.constant = keyboardSize.height
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    self.bottomConstraint.constant = 0
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onSave(sender: AnyObject) {
    // Do nothing if invalid email
    if !Validator.isValidEmail(emailTextField.text) {
      let alertController = UIAlertController(title: "", message:
        "Please enter a valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
      return
    }
    
    var user = User.getUserFromDefaults()
    if user == nil {
      return
    }
    user!.emailAddress = emailTextField.text
    user!.update { (result, error) -> () in
      let alertController = UIAlertController(title: "", message:
        "Your email has been updated!", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  @IBAction func checkEmailAddress(sender: UITextField) {
    if !Validator.isValidEmail(sender.text) {
      Validator.highlightError(sender)
    } else {
      Validator.unhighlightError(sender)
    }
  }
  

}
