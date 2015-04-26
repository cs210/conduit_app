//
//  MenuTableViewController.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

  var menuOptions = ["Scanner", "Conversations", "Settings", "Invite Friends"]
  
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
      
    if menuOptions[indexPath.row] == "Scanner" {
      performSegueWithIdentifier("scanner_segue", sender: self)
    } else if menuOptions[indexPath.row] == "Conversations" {
      performSegueWithIdentifier("conversations_segue", sender: self)
    } else if menuOptions[indexPath.row] == "Settings" {
      performSegueWithIdentifier("settings_segue", sender: self)
    } else if menuOptions[indexPath.row] == "Invite Friends" {
      performSegueWithIdentifier("invite_friends_segue", sender: self)
    }
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
