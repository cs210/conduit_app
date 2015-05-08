//
//  SettingsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit
import GoogleAnalytics_iOS_SDK

class SettingsViewController : UITableViewController, ConfirmPasswordDelegate {
  var menuOptions = ["Change Name", "Change Password", "Change Email", "Change Phone Number", "Change Push Notifications", "Car Management"]
  var segueOptions = ["change_name_segue", "change_password_segue", "change_email_segue", "change_phone_segue", "change_push_notifs_segue", "car_management_segue"]

  @IBOutlet weak var menuButton: UIButton!
  
  override func viewDidLoad() {
    var defaults = NSUserDefaults.standardUserDefaults()
    println(defaults.stringForKey("session"))
    super.viewDidLoad()
    menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("Settings")
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SettingsListItem",
      forIndexPath : indexPath) as! UITableViewCell
    
    cell.textLabel?.text = menuOptions[indexPath.row]
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuOptions.count
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // TODO: This is where we go to a new view.
    var cell = tableView.cellForRowAtIndexPath(indexPath)
    if (indexPath.row == 1 || indexPath.row == 2){
      performSegueWithIdentifier("confirm_password_segue", sender: cell)
    } else {
      performSegueWithIdentifier(segueOptions[indexPath.row], sender: cell)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "confirm_password_segue") {
      var next = segue.destinationViewController as! ConfirmPasswordViewController
      next.delegate = self
      var cell = sender as! UITableViewCell
      var nextSegueID = segueOptions[tableView.indexPathForCell(cell)!.row]
      next.nextSegueID = nextSegueID
    }
  }
  func nextSegueAfterConfirm(segueId: String) {
    self.navigationController?.viewControllers.removeLast()
    performSegueWithIdentifier(segueId, sender: self)
  }
  
  
}