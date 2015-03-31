//
//  NewMessageViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 3/8/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class NewMessageViewController : UIViewController, UITableViewDataSource {
  // Init selected message to "" because  you can't send an empty message
  var selectedMessage = ""
  var presetMessages = [
    "Could you please unlock your charging port? Thank you!",
    "When will you be back to your car?",
    "Move your car now or else."
  ]

  @IBOutlet weak var presetTable: UITableView!
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presetMessages.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PresetListItem", forIndexPath: indexPath) as NewMessageTableViewCell
      
    cell.label.text = presetMessages[indexPath.row]
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as NewMessageTableViewCell
    selectedMessage = cell.label.text!
  }
  
}

class NewMessageTableViewCell : UITableViewCell {
  @IBOutlet weak var label: UILabel!
}
