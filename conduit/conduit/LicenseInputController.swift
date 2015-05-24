//
//  LicenseInputController.swift
//  conduit
//
//  Created by Nathan Eidelson on 5/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation

class LicenseInputController : UIViewController, SWRevealViewControllerDelegate {

  @IBOutlet weak var licenseField: UITextField!
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var hasChanged = false
  var participantIdentifiers: [String] = []
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    StyleHelpers.setButtonFont(continueButton)
    StyleHelpers.setButtonFont(menuButton)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    licenseField.becomeFirstResponder()
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func viewDidLoad() {
    // Setup reveal view controller
    self.revealViewController().delegate = self
    var swipeRight = UISwipeGestureRecognizer(target: self.revealViewController(), action: "revealToggle:")
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    self.view.addGestureRecognizer(swipeRight)
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
    
    continueButton.backgroundColor = StyleColor.getColor(.Grey, brightness: .Medium)
    
    var timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self,
      selector: "checkTimerFunction", userInfo: nil, repeats: true)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    StyleHelpers.disableAutocorrect(licenseField)
    StyleHelpers.setBackButton(self.navigationItem, label: "Back")
    
  }
  
  func revealController(revealController: SWRevealViewController!,  willMoveToPosition position: FrontViewPosition){
    if(position == FrontViewPosition.Left) {
       self.view.userInteractionEnabled = true
    } else {
       self.view.userInteractionEnabled = false
    }
  }
  
  func revealController(revealController: SWRevealViewController!,  didMoveToPosition position: FrontViewPosition){
    if(position == FrontViewPosition.Left) {
       self.view.userInteractionEnabled = true
    } else {
       self.view.userInteractionEnabled = false
    }
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
        self.scrollView.scrollRectToVisible(self.continueButton.frame, animated: false)
        }, completion: nil)
      
      self.scrollView.scrollRectToVisible(self.continueButton.frame, animated: true)
      
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
  
  func presentErrorMessage () {
    var message = "Sorry, we could not find any owners of that car."
    let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  @IBAction func continueButtonPressed(sender: AnyObject) {
    self.checkCurrentLicense(true, completion: { () -> () in
      self.performSegueWithIdentifier("to_new_message", sender: self)
    })
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "to_new_message" {
      var target: NewMessageViewController = segue.destinationViewController as! NewMessageViewController
      target.participantIdentifiers = self.participantIdentifiers
      target.licensePlate = self.licenseField.text
    }
  }
  
  func checkTimerFunction () {
    self.checkCurrentLicense(false, completion: nil)
  }
  
  @IBAction func licensePlateChanged(sender: AnyObject) {
    self.hasChanged = true
  }

  func checkCurrentLicense (presentErrors: Bool, completion: (()->())?) {
    
    if (!self.hasChanged && !presentErrors) {
      return
    }
    
    NSLog("checkCurrentLicense")
    self.hasChanged = false
    var session = NSUserDefaults().stringForKey("session")!
    
    APIModel.get("cars/\(licenseField.text)/users?session_token=\(session)", parameters: nil) {(result, error) in
    
      if error != nil {
        NSLog("No car found.")
        self.continueButton.backgroundColor = StyleColor.getColor(.Grey, brightness: .Medium)
        if presentErrors {
          self.presentErrorMessage()
        }
        return
      }
      self.participantIdentifiers = []
      
      var userList = result!["users"]
    
      if userList.count == 0 {
        NSLog("No users for car.")
        self.continueButton.backgroundColor = StyleColor.getColor(.Grey, brightness: .Medium)
        if presentErrors {
          self.presentErrorMessage()
        }
        return
      }
      
      for (var i = 0; i < userList.count; i++) {
        var participantIdentifier = userList[i]["email_address"].stringValue
        self.participantIdentifiers.append(participantIdentifier)
      }
      
      self.continueButton.backgroundColor = StyleColor.getColor(.Primary, brightness: .Medium)
      
      if let block = completion {
        block()
      }
      
    }
  }
  
  
}