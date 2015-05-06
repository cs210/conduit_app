//
//  NewMessageViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 3/8/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class NewMessageViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
  // Init selected message to "" because  you can't send an empty message
  var selectedMessage = ""
  var presetMessages = [
    "Could you please unlock your charging port? Thank you!",
    "When will you be back to your car?",
    "Move your car now or else."
  ]
  var manualLicensePlate : Bool!
  var participantIdentifiers : [String] = []

  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var toFieldBackground: UIView!
  @IBOutlet weak var licenseTextField: UITextField!
  @IBOutlet weak var presetTable: UITableView!
  var licensePlate : String!
  
  // These variables make sure that tapping works as expected
  // i.e. when you tap anywhere when keyboard is enabled, it is dismissed
  @IBOutlet var keyboardDismisser: UITapGestureRecognizer!
  
  override func viewDidLoad() {
    
    var sessionKey = NSUserDefaults.standardUserDefaults().stringForKey("session")
    // testing if the session key is actually valid...
    if (sessionKey == nil) {
      performSegueWithIdentifier("to_login", sender: self)
    }
    
    toFieldBackground.backgroundColor = StyleColor.getColor(.Grey, brightness: .Light)
    licenseTextField.text = ""
    licenseTextField.becomeFirstResponder()
    licenseTextField.autocorrectionType = UITextAutocorrectionType.No
    
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
    
  }
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
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
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    sendMessageToLicensePlate(licenseTextField.text)
  }
  
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    var button = UIButton()
    button.setTitle("Custom", forState: .Normal)
    button.addTarget(self, action: "goToCustomMessage", forControlEvents: UIControlEvents.TouchUpInside)
    button.titleLabel!.font = UIFont.systemFontOfSize(14.0)
    return button
  }
  
  func goToCustomMessage() {
    self.performSegueWithIdentifier("custom_message_segue", sender: self)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 50.0
  }
  
  // This function ensures that data from this view (i.e. license plate) is sent
  // correctly to the custom message view.
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "custom_message_segue" {
      view.endEditing(true)
      var next = segue.destinationViewController as! CustomMessageController
      next.licensePlate = licenseTextField.text
    }
    if segue.identifier == "send_to_conversation" {
//      var next = segue.destinationViewController as! ConversationListViewController
//      next.newParticipantIdentifiers = self.participantIdentifiers
    }
  }
  
  func sendMessageToLicensePlate(licensePlate : String) {
    var session = NSUserDefaults().stringForKey("session")!
    self.participantIdentifiers = []
    
    // /cars/license_plate/users
    APIModel.get("cars/\(licensePlate)/users?session_token=\(session)", parameters: nil) {(result, error) in
      if error != nil {
        NSLog("No car for license plate")
        let alertController = UIAlertController(title: "", message: "We could not find owners of a car with that license plate.",
          preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
        self.selectedMessage = ""
        return
      }
      
      var userList = result!["users"]
      if userList != nil  {
        for (var i = 0; i<userList.count; i++) {
          var userJSON = userList[i]
          var participantIdentifier = userJSON["email_address"].stringValue
          self.participantIdentifiers.append(participantIdentifier)
        }
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
