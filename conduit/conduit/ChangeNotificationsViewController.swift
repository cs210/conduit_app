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
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onSave(sender: AnyObject) {
    AnalyticsHelper.trackButtonPress("change_notifications")
    var user = User.getUserFromDefaults()
    if user == nil {
      return
    }
    user?.pushEnabled = changeNotificationSwitch.on
    user!.update { (result, error) -> () in
      
      var message = error == nil ? "Your push notification settings have been updated!" : "There was an error, please try again later."
      
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
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
}
