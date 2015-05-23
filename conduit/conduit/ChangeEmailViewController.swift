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
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var scrollView: UIScrollView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ChangeEmail")
    StyleHelpers.setButtonFont(saveButton)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    emailTextField.becomeFirstResponder()
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
    AnalyticsHelper.trackButtonPress("change_email")
    
    // Do nothing if invalid email
    if !Validator.isValidEmail(emailTextField.text) {
      let alertController = UIAlertController(title: "", message:
        "Please enter a valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(action) in
        self.navigationController?.popViewControllerAnimated(true)
      }))
      
      self.presentViewController(alertController, animated: true, completion: nil)
      return
    }
    
    var user = User.getUserFromDefaults()
    if user == nil {
      return
    }
    
    user!.emailAddress = emailTextField.text
    user!.update { (result, error) -> () in
      
      var message = error == nil ? "Your email address has been updated!" : "There was an error, please try again later."
      
      if error == nil {
        User.updateUserInDefaults(result!)
      }
      
      let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
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
