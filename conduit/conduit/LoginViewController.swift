//
//  LoginViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var newAcctButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var conduitLabel: UILabel!
  @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
  
  @IBOutlet var scrollView: UIScrollView!
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("Login")

    self.navigationController?.setNavigationBarHidden(true, animated: false)
    self.newAcctButton.backgroundColor = nil
    self.loginButton.backgroundColor = nil
    self.conduitLabel.font = UIFont(name: StyleHelpers.FONT_NAME, size: 70.0)
    self.conduitLabel.textColor = TextColor.getTextColor(.Light)
    
    StyleHelpers.setButtonFont(loginButton)
    StyleHelpers.setButtonFont(newAcctButton)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailField.delegate = self
    passwordField.delegate = self
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    StyleHelpers.disableAutocorrect(emailField)
    StyleHelpers.disableAutocorrect(passwordField)
    
//    Nisha is testing crash reporting
//    NSException(name: "SomeName", reason: "SomeReason", userInfo: nil).raise()

  }
  
  func keyboardWillShow(notification: NSNotification) {
    var info = notification.userInfo as! [String: NSObject]
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
      var screenSize = UIScreen.mainScreen().bounds
      if (screenSize.height < 500) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height/3), animated: true)
      }
    }
    
  }
  
  func keyboardWillHide(notification: NSNotification) {
    self.scrollView.setContentOffset(CGPointZero, animated: true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    println("inside")
    if (textField == emailField) {
      passwordField.becomeFirstResponder()
    }
    if (textField == passwordField) {
      loginPressed(self)
    }
    return true;
  }
  
  @IBAction func loginPressed(sender: AnyObject) {
    self.startLogin()
    
    let params = ["password": passwordField.text, "email_address": emailField.text]
    
    // Create a new session for the user, logging them into their account.
    APIModel.post("sessions", parameters: params) { (result, error) -> () in
      if (error != nil) {
        let alertController = UIAlertController(title: "", message: "There was an error logging into your account. Please try again.",
          preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        self.stopLogin(true)
        return
      }
      
      var defaults = NSUserDefaults.standardUserDefaults()
      var sessionKey = result!["session_token"].string!
      defaults.setValue(sessionKey, forKey: "session")

      var user = User(json: result!["user"])
      let encodedUser = NSKeyedArchiver.archivedDataWithRootObject(user)
      defaults.setObject(encodedUser, forKey: "user")

      Car.loadCars({ (result, error) -> () in
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.authenticateWithLayer({(success, error) in
          if !success {
            self.stopLogin(true)
            return
          }
          self.proceeedFromLogin()
        })
      })
    }
  }
  
  func proceeedFromLogin() {
    self.dismissViewControllerAnimated(false, completion: {
      self.stopLogin(false)
      if NSUserDefaults.standardUserDefaults().boolForKey("isNewAccount") {
        // Go to welcome view
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let destViewController : WelcomeViewController = mainStoryboard.instantiateViewControllerWithIdentifier("welcomeView") as! WelcomeViewController
        
        // This is eventually what we want to do. Right now it gives a blank screen.
        var destNavController = UINavigationController(rootViewController: destViewController)
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var revealController : SWRevealViewController = appDelegate.window!.rootViewController as! SWRevealViewController
        var navController : UINavigationController = revealController.frontViewController as! UINavigationController
        
        navController.presentViewController(destNavController, animated: true, completion: nil)
        
      } else {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var revealController : SWRevealViewController = appDelegate.window!.rootViewController as! SWRevealViewController
        var navController : UINavigationController = revealController.frontViewController as! UINavigationController
        
        var licenseInputViewController = navController.topViewController as! LicenseInputController?
        licenseInputViewController?.licenseField.becomeFirstResponder()
      }
    })
  }
  
  func startLogin() {
    AnalyticsHelper.trackButtonPress("log_in")
    self.waitingIndicator.startAnimating()
    self.loginButton.enabled = false
    self.newAcctButton.enabled = false
  }
  
  func stopLogin(err : Bool) {
    if err {
      let alertController = UIAlertController(title: "", message: "There was an error logging into your account. Please try again.",
        preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    self.waitingIndicator.stopAnimating()
    self.loginButton.enabled = true
    self.newAcctButton.enabled = true
  }
  
  @IBAction func noAccountPressed(sender: AnyObject) {
    AnalyticsHelper.trackButtonPress("newAccount")
  }
  
  
}