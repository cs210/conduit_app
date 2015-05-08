//
//  PhoneSettingsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 5/1/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

class PhoneSettingsViewController: UIViewController {
  @IBOutlet var phoneField: UITextField!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ChangePhone")
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
//      phoneField.placeholder = User.getUserFromDefaults()?.phoneNumber
      // Do any additional setup after loading the view.
    Validator.highlightError(phoneField)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    phoneField.autocorrectionType = UITextAutocorrectionType.No
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
  
  @IBAction func onSave(sender: AnyObject) {
    AnalyticsHelper.trackButtonPress("change_phone_number")
    
    // Do nothing if invalid phone number
    if !Validator.isValidPhoneNumber(phoneField.text) {
      let alertController = UIAlertController(title: "", message:
        "Please enter a valid phone number.", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
      return
    }
    
    
    var user = User.getUserFromDefaults()
    if user == nil {
      return
    }
    user?.phoneNumber = phoneField.text
    user!.update { (result, error) -> () in
      let alertController = UIAlertController(title: "", message:
        "Your phone number has been updated!", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }

  @IBAction func checkPhoneNumber(sender: UITextField) {
    if !Validator.isValidPhoneNumber(sender.text) {
      Validator.highlightError(sender)
    } else {
      Validator.unhighlightError(sender)
    }
  }
  
  @IBAction func onTap(sender: AnyObject) {
    view.endEditing(true)
  }
}
