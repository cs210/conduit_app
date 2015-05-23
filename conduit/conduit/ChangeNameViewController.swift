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
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var saveButton: UIButton!
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ChangeName")
    StyleHelpers.setButtonFont(saveButton)
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
    var user = User.getUserFromDefaults()
    firstNameField.text = user?.firstName
    lastNameField.text = user?.lastName
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
    
  @IBAction func saveChanges(sender: AnyObject) {
    AnalyticsHelper.trackButtonPress("change_name")
    var user = User.getUserFromDefaults()
    if user == nil {
      return
    }

    user?.firstName = firstNameField.text
    user?.lastName = lastNameField.text
    user!.update { (result, error) -> () in
      
      var message = error == nil ? "Your name has been updated!" : "There was an error, please try again later."
      
      if error == nil {
        User.updateUserInDefaults(result!)
      }
      
      let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(action) in
        self.navigationController?.popViewControllerAnimated(true)
      }))
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }

}
