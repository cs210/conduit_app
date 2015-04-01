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
  // fake data for testing
  var fakeLicensePlate = "ABC123"

  @IBOutlet weak var licenseTextField: UITextField!
  @IBOutlet weak var presetTable: UITableView!
  
  // These variables make sure that tapping works as expected
  // i.e. when you tap anywhere when keyboard is enabled, it is dismissed
  // i.e. when you tap to select a table cell, tapping elsewhere deselects it
  @IBOutlet var keyboardDismisser: UITapGestureRecognizer!

  @IBOutlet var presetDeselecter: UITapGestureRecognizer!
  
  override func viewDidLoad() {
    keyboardDismisser.enabled = false
    presetDeselecter.enabled = false
    licenseTextField.text = fakeLicensePlate
  }
  
  // These functions ensure correct tapping to dismiss keyboard and to deselect
  // table cells
  @IBAction func enableKeyboardDismisser(sender: AnyObject) {
    keyboardDismisser.enabled = true
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
  
  // These functions manage the preset message list.
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
  
  // This function ensures that data from this view (i.e. license plate) is sent
  // correctly to the custom message view.
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "customMessageSegue" {
      var next = segue.destinationViewController as CustomMessageController
      next.licensePlate = licenseTextField.text
    }
  }
  
  // This is the function to actually send a message. TODO: include API calls.
  @IBAction func sendMessage(sender: AnyObject) {
    // if there's no selected custom message, the send button does nothing.
    if selectedMessageIndexPath == nil {
      return
    }
    
    // TODO: send the message here.
    
  }
}

// We have a custom table cell which contains a label, so that we can customize
// the look and positioning of table cells.
class NewMessageTableViewCell : UITableViewCell {
  @IBOutlet weak var label: UILabel!
}
