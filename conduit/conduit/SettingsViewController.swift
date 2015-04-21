//
//  SettingsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UITableViewController, ConfirmPasswordDelegate {
  var menuOptions = ["Account Settings", "Privacy Settings", "Car Management"]
  var segueOptions = ["account_settings_segue", "privacy_settings_segue", "car_management_segue"]

  @IBOutlet weak var menuButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
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
    performSegueWithIdentifier("confirm_password_segue", sender: tableView.cellForRowAtIndexPath(indexPath))
    
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