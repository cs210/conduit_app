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
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var saveButton: UIButton!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ChangePhone")
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
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
      
      let animationDuration : NSTimeInterval = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
      
      var contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0,0.0,keyboardSize.height, 0.0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
      
      var aRect : CGRect = self.view.frame
      aRect.size.height -= keyboardSize.height
      
      UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
        self.scrollView.scrollRectToVisible(self.saveButton.frame, animated: false)
        }, completion: nil)
      
      self.scrollView.scrollRectToVisible(self.saveButton.frame, animated: true)
      
    }
    
  }
  
  func keyboardWillHide(notification: NSNotification) {
    var contentInsets : UIEdgeInsets  = UIEdgeInsetsZero
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
    
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
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(action) in
        self.navigationController?.popViewControllerAnimated(true)
      }))
      
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
