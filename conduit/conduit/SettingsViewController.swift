//
//  SettingsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UITableViewController, ConfirmPasswordDelegate, SWRevealViewControllerDelegate {
  var menuOptions = ["Change Name", "Change Password", "Change Email", "Change Phone Number", "Change Push Notifications", "Car Management"]
  var segueOptions = ["change_name_segue", "change_password_segue", "change_email_segue", "change_phone_segue", "change_push_notifs_segue", "car_management_segue"]
  
  override func viewDidLoad() {
    // Setup reveal view controller
    self.revealViewController().delegate = self
    var swipeRight = UISwipeGestureRecognizer(target: self.revealViewController(), action: "revealToggle:")
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    self.view.addGestureRecognizer(swipeRight)
    
    var menuIcon = UIImage(named: "menu.png") as UIImage!
    
    var barButton = UIBarButtonItem(image: menuIcon, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: "revealToggle:")
    self.navigationItem.leftBarButtonItem = barButton
    
    var defaults = NSUserDefaults.standardUserDefaults()
    println(defaults.stringForKey("session"))
    super.viewDidLoad()

    StyleHelpers.setBackButton(self.navigationItem, label: "Back")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("Settings")
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
    AnalyticsHelper.trackTouchEvent(segue.identifier!)
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