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
  var selectedMessageIndexPath : NSIndexPath?
  
  var presetMessages = [
    "Could you please unlock your charging port? Thank you!",
    "When will you be back to your car?",
    "Move your car now or else."
  ]

  @IBOutlet weak var presetTable: UITableView!
  
  @IBOutlet var keyboardDismisser: UITapGestureRecognizer!

  @IBOutlet var presetDeselecter: UITapGestureRecognizer!
  
  @IBAction func enableKeyboardDismisser(sender: AnyObject) {
    keyboardDismisser.enabled = true
  }
  
  override func viewDidLoad() {
    keyboardDismisser.enabled = false
    presetDeselecter.enabled = false
  }
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
    keyboardDismisser.enabled = false
  }
  
  @IBAction func deselectSelectedMessage(sender: AnyObject) {
    if (selectedMessageIndexPath != nil) {
      presetTable.deselectRowAtIndexPath(selectedMessageIndexPath!, animated: false)
      selectedMessageIndexPath = nil
      selectedMessage = ""
      presetDeselecter.enabled = false
    }
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
    selectedMessageIndexPath = indexPath
    presetDeselecter.enabled = true
  }
}

class NewMessageTableViewCell : UITableViewCell {
  @IBOutlet weak var label: UILabel!
}
