//
//  SettingsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UITableViewController {
  var menuOptions = ["Account Settings", "Privacy Settings", "Car Management"]

  @IBOutlet weak var menuButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)

  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SettingsListItem",
      forIndexPath : indexPath) as UITableViewCell
    
    cell.textLabel?.text = menuOptions[indexPath.row]
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuOptions.count
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // TODO: This is where we go to a new view.
    
    if menuOptions[indexPath.row] == "Account Settings" {
      performSegueWithIdentifier("account_settings_segue", sender: self)
    } else if menuOptions[indexPath.row] == "Privacy Settings" {
      performSegueWithIdentifier("privacy_settings_segue", sender: self)
    } else if menuOptions[indexPath.row] == "Car Management" {
      performSegueWithIdentifier("car_management_segue", sender: self)
    }
  }
}