//
//  ChangePasswordView.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordView : UIViewController {
  
  @IBOutlet var newPasswordField: UITextField!
  @IBOutlet var confirmPasswordField: UITextField!
  
  @IBOutlet var scrollView : UIScrollView!
  @IBOutlet var saveButton : UIButton!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ChangePassword")
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    newPasswordField.becomeFirstResponder()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
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
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  @IBAction func savePassword(sender: AnyObject) {
    AnalyticsHelper.trackButtonPress("change_password")
    var error = false
    if newPasswordField.text == "" {
      return
    }
    if (newPasswordField.text != confirmPasswordField.text) {
      var alert = UIAlertController(title: "Error", message: "Passwords don't match!", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
      error = true
    } else {
      var user = User.getUserFromDefaults()
      if user == nil {
        return
      }
      
      user!.updatePassword(newPasswordField.text, completion: { (result, error) -> () in
        let alertController = UIAlertController(title: "", message:
          "Your password has been updated!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(action) in
          self.navigationController?.popViewControllerAnimated(true)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
      })
    }
  }
 
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "notify_changed_password_segue") {
      println("notifying!")
      self.navigationController?.viewControllers.removeLast()
    }
  }
  
}
