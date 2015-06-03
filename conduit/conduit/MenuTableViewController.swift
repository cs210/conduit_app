//
//  MenuTableViewController.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

  var menuOptions = ["Make A Request", "Conversations", "Settings", "Invite Friends", "Log Out"]

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("Menu")
  }

  override func viewDidLoad() {
    var swipeLeft = UISwipeGestureRecognizer(target: self.revealViewController(), action: "revealToggle:")
    swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
    self.view.addGestureRecognizer(swipeLeft)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MenuItem",
          forIndexPath : indexPath) as! UITableViewCell
      
      cell.textLabel!.text = menuOptions[indexPath.row]
      return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return menuOptions.count
  }
  
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      // TODO: This is where we go to a new view.
      
    if menuOptions[indexPath.row] == "Make A Request" {
      performSegueWithIdentifier("request_segue", sender: self)
    } else if menuOptions[indexPath.row] == "Conversations" {
      performSegueWithIdentifier("conversations_segue", sender: self)
    } else if menuOptions[indexPath.row] == "Settings" {
      performSegueWithIdentifier("settings_segue", sender: self)
    } else if menuOptions[indexPath.row] == "Invite Friends" {
      performSegueWithIdentifier("invite_friends_segue", sender: self)
    } else if menuOptions[indexPath.row] == "Log Out" {
      confirmLogout()
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
  
  func confirmLogout() {
    var alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
      self.performLogOut()
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))

    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func performLogOut() {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.layerClient?.deauthenticateWithCompletion({ (success, err) -> Void in
      if err != nil {
        NSLog("Deauthenticate with Layer failed with error: \(err)")
        var alert = UIAlertController(title: "Error", message: "There was an error logging you out. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
      } else {
      
        appDelegate.logout()
        appDelegate.goToLogin()
      }

    })
    
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "conversations_segue" {
      
      var conversationListNavigationController: UINavigationController = segue.destinationViewController  as! UINavigationController
      var conversationListController: ConversationListViewController = conversationListNavigationController.visibleViewController as! ConversationListViewController
      var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      conversationListController.layerClient = appDelegate.layerClient
    }
  }
}


