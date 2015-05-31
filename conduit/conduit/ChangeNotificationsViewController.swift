//
//  ChangeNotificationsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/29/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

class ChangeNotificationsViewController: UIViewController {
  @IBOutlet var changeNotificationSwitch: UISwitch!
  @IBOutlet weak var saveButton: UIButton!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ChangeNotifications")
    StyleHelpers.setButtonFont(saveButton)
    
    var user = User.getUserFromDefaults()
    if let pushEnabled = user?.pushEnabled {
      if pushEnabled {
        changeNotificationSwitch.setOn(true, animated: false)
      } else {
        changeNotificationSwitch.setOn(false, animated: false)
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(false)
  }

  @IBAction func onSave(sender: AnyObject) {
    AnalyticsHelper.trackButtonPress("change_notifications")
    var user = User.getUserFromDefaults()
    if user == nil {
      return
    }
    
    let setPush = changeNotificationSwitch.on

    var defaults = NSUserDefaults.standardUserDefaults()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var deviceToken : NSData? = defaults.valueForKey("deviceToken")?.data
    
    // turn push notifications on
    if setPush {
      // if push notifs are off, turn them on
      if user!.pushEnabled == false {
        
        // if there's no device token already, we have to go through the entire process of registering
        if deviceToken == nil {
          appDelegate.registerApplicationForPushNotifications(UIApplication.sharedApplication())
        }
        
        // if there is a device token, we can just set it below as per usual
      }
    // turn push notifications off
    } else {
      // if push notifs are on, turn them off
      if user!.pushEnabled {
        deviceToken = nil
      }
    }
    
    // First, we're going to update the user. If that's successful, we'll update layer.
    // Then, if updating layer fails, we fix the user.
    
    
    // Let's update the user
    let oldPushStatus = user!.pushEnabled
    user!.pushEnabled = changeNotificationSwitch.on
    
    // Updating the user
    user!.update { (result, err) -> () in
      
      var message = err == nil ? "Your push notification settings have been updated!" : "There was an error, please try again later."
      
      // If the update goes well
      if err == nil {
        
        // Let's update layer, too
        var error: NSError?
        var success = appDelegate.layerClient?.updateRemoteNotificationDeviceToken(deviceToken, error: &error)
        
        // If layer update doesn't work, reset.
        if success == nil {
          user!.pushEnabled = oldPushStatus
          user!.update { (result, err) -> () in
            // if there is an error here, shit gets awkward really fast.
          }
          message = "There was an error, please try again later."
        // If layer update goes well, update defaults and done!
        } else {
          User.updateUserInDefaults(result!)
        }
      // If user update doesn't go well
      } else {
        NSLog("Failed to update push notification user settings with error: \(err)")
      }
      
      
      let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(action) in
        self.navigationController?.popViewControllerAnimated(true)
      }))
      self.presentViewController(alertController, animated: true, completion: nil)
    }
    
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
}
