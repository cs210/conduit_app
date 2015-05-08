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

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ChangeNotifications")
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
      let alertController = UIAlertController(title: "", message:
        "Your settings have been updated!", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
      
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
