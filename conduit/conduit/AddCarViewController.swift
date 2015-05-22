//
//  AddCarViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 5/6/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class AddCarViewController : UIViewController {
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var licensePlateField: UITextField!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var addCarButton: UIButton!
  var carManagementFlag : Bool = false
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("AddCar")
    
    StyleHelpers.setButtonFont(cancelButton)
    StyleHelpers.setButtonFont(doneButton)

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if carManagementFlag {
      doneButton.hidden = true
    } else {
      cancelButton.hidden = true
    }
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    StyleHelpers.disableAutocorrect(licensePlateField)
    

    
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
        self.scrollView.scrollRectToVisible(self.addCarButton.frame, animated: false)
      }, completion: nil)

      self.scrollView.scrollRectToVisible(addCarButton.frame, animated: true)
      
    }

  }
  
  func keyboardWillHide(notification: NSNotification) {
    var contentInsets : UIEdgeInsets  = UIEdgeInsetsZero
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if !licensePlateField.becomeFirstResponder() {
      NSLog("crying")
    }
    
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  
  @IBAction func addCar(sender : AnyObject) {
    AnalyticsHelper.trackButtonPress("add_car")
    if licensePlateField.text == "" {
      Validator.highlightError(licensePlateField)
      let alertController = UIAlertController(title: "", message:
        "Please enter a license plate to add a car to your account.", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
      
      self.presentViewController(alertController, animated: true, completion: nil)
      return
    }
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var sessionToken : String = defaults.valueForKey("session") as! String
    let params = ["license_plate": self.licensePlateField.text, "manufacturer": ""]

    APIModel.post("users/\(sessionToken)/cars", parameters: params) { (result, error) -> () in
      if (error != nil) {
        NSLog("Error creating car")
        let alertController = UIAlertController(title: "", message: "There was an error creating this car. Please try again.",
          preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
        return
      }

      // if there is no error -> create car succeeded!

      let alertController = UIAlertController(title: "Car created!", message: "",
        preferredStyle: UIAlertControllerStyle.Alert)

      alertController.addAction(UIAlertAction(title: "Add another car", style: UIAlertActionStyle.Default,handler: nil))

      alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default,handler: {(action) in
        self.doDoneTransition()
      }))

      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  @IBAction func doneFunction(sender: AnyObject) {
    doDoneTransition()
  }
  
  
  func doDoneTransition() {
    if self.carManagementFlag {
      let prevVC : CarManagementView = self.getPreviousViewController() as! CarManagementView
      prevVC.loadCars()
      self.navigationController?.popViewControllerAnimated(true)
      return
    }
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let destViewController : InviteFriendsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("inviteFriendsView") as! InviteFriendsViewController
    self.navigationController?.pushViewController(destViewController, animated: true)
    
  }
  
  func getPreviousViewController() -> UIViewController? {
    let numVCs = self.navigationController!.viewControllers.count
    
    if numVCs < 2 {
      return nil
    }
    
    return self.navigationController!.viewControllers[numVCs - 2] as! UIViewController
  }
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  
}