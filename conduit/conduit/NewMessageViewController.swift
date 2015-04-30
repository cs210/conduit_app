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
  var licensePlate : String!
  var manualLicensePlate : Bool!
  var participantIdentifiers : [String]?

  @IBOutlet weak var toFieldBackground: UIView!
  @IBOutlet weak var licenseTextField: UITextField!
  @IBOutlet weak var presetTable: UITableView!
  
  // These variables make sure that tapping works as expected
  // i.e. when you tap anywhere when keyboard is enabled, it is dismissed
  @IBOutlet var keyboardDismisser: UITapGestureRecognizer!
  
  override func viewDidLoad() {
    keyboardDismisser.enabled = false
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
    
    sendMessageToLicensePlate(licensePlate)
  }
  
  // This function ensures that data from this view (i.e. license plate) is sent
  // correctly to the custom message view.
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "custom_message_segue" {
      var next = segue.destinationViewController as! CustomMessageController
      next.licensePlate = licenseTextField.text
    }
    if segue.identifier == "send_to_conversation" {
      var next = segue.destinationViewController as! ConversationViewController
      next.participantIdentifiers = participantIdentifiers
    }
  }
  
  func sendMessageToLicensePlate(licensePlate : String) {
    var session = NSUserDefaults().stringForKey("session")
    
    participantIdentifiers = []
    
    // /cars/license_plate/users
    APIModel.get("cars/\(licensePlate)/users?session_token=\(session)", parameters: nil) {(result, error) in
      if error != nil {
        NSLog("No car for license plate")
        let alertController = UIAlertController(title: "", message: "We could not find owners of a car with that license plate.",
          preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
        return
      }
      
      for (var i=0; i<result?.count; i++){
        var userJson = result![i]
        var participantIdentifier = userJson["participant_identifier"].stringValue
        self.participantIdentifiers!.append(participantIdentifier)
      }
      
      NSLog("Going to send_to_conversation segue")
      self.performSegueWithIdentifier("send_to_conversation", sender: self)
      
    }
  
  }

}

// We have a custom table cell which contains a label, so that we can customize
// the look and positioning of table cells.
class NewMessageTableViewCell : UITableViewCell {
  @IBOutlet weak var label: UILabel!
}
