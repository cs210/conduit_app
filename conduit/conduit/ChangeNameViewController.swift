//
//  ChangeNameViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/29/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

class ChangeNameViewController: UIViewController {
  @IBOutlet var lastNameField: UITextField!
  @IBOutlet var firstNameField: UITextField!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ChangeName")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    firstNameField.autocorrectionType = UITextAutocorrectionType.No
    lastNameField.autocorrectionType = UITextAutocorrectionType.No
  
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
    
  @IBAction func saveChanges(sender: AnyObject) {
    var user = User.getUserFromDefaults()
    if user == nil {
      return
    }

    user?.firstName = firstNameField.text
    user?.lastName = lastNameField.text
    user!.update { (result, error) -> () in
      let alertController = UIAlertController(title: "", message:
        "Your name has been updated!", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }

}
