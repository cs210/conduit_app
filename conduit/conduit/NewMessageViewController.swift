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
  var licensePlate : String!
  var manualLicensePlate : Bool!

  @IBOutlet weak var toFieldBackground: UIView!
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
    toFieldBackground.backgroundColor = StyleColor.getColor(.Grey, brightness: .Light)
    if manualLicensePlate == true {
      licenseTextField.text = ""
      licenseTextField.becomeFirstResponder()
    } else {
      licenseTextField.text = licensePlate
      licenseTextField.textColor = StyleColor.getColor(.Grey, brightness: .Dark)
    }
  }
  
  // These functions ensure correct tapping to dismiss keyboard and to deselect
  // table cells
  @IBAction func enableKeyboardDismisser(sender: AnyObject) {
    keyboardDismisser.enabled = true
  }
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
    keyboardDismisser.enabled = false
    if licenseTextField.text == "" {
      licenseTextField.text = "License Plate"
      licenseTextField.textColor = StyleColor.getColor(.Grey, brightness: .Light)
      licensePlate = ""
    } else {
      licensePlate = licenseTextField.text
    }
  }
  
  @IBAction func manualLicensePlate(sender: AnyObject) {
    if licensePlate != "" {
      return
    }
    
    licenseTextField.text = ""
    licenseTextField.textColor = UIColor.blackColor()
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
    let cell = tableView.dequeueReusableCellWithIdentifier("PresetListItem", forIndexPath: indexPath) as! NewMessageTableViewCell
      
    cell.label.text = presetMessages[indexPath.row]
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! NewMessageTableViewCell
    selectedMessage = cell.label.text!
    selectedMessageIndexPath = indexPath
    presetDeselecter.enabled = true
  }
  
  // This function ensures that data from this view (i.e. license plate) is sent
  // correctly to the custom message view.
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "custom_message_segue" {
      var next = segue.destinationViewController as! CustomMessageController
      next.licensePlate = licenseTextField.text
    }
  }
  
  func sendMessageToLicensePlate(licensePlate : String) {
    var session = NSUserDefaults().stringForKey("session")
    var parameters = ["license_plate": licensePlate]
    var userIds : [String] = []
    APIModel.get("users", parameters: parameters) {(result, error) in
      if error != nil {
        NSLog("No car for license plate")
        let alertController = UIAlertController(title: "", message: "We could not find owners of a car with that license plate.",
          preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
        return
      }
      
      for (var i=0; i<result?.count; i++){
        var userIdJson = result![i]
        var userId = userIdJson["id"].stringValue
        userIds.append(userId)
      }
    }
    
    for userId in userIds {
      // Send message using Layer
      // We should probably have one method that does all of these calls
    }

    // Callback code:
    
//    if error != nil {
//      NSLog("Error sending message")
//      let alertController = UIAlertController(title: "", message: "Could not send message. Please try again.",
//        preferredStyle: UIAlertControllerStyle.Alert)
//      alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
//      
//      self.presentViewController(alertController, animated: true, completion: nil)
//      return
//    }
//    
    NSLog("Going to send_to_conversation segue")
    self.performSegueWithIdentifier("send_to_conversation", sender: self)
  }
  
  @IBAction func sendPressed(sender: AnyObject) {
    // if there's no selected custom message or license plate, the send button does nothing.
    if selectedMessageIndexPath == nil || licenseTextField.text == "" {
      return
    }

    sendMessageToLicensePlate(licensePlate)
  }

}

// We have a custom table cell which contains a label, so that we can customize
// the look and positioning of table cells.
class NewMessageTableViewCell : UITableViewCell {
  @IBOutlet weak var label: UILabel!
}
