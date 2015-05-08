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
  
  var licensePlate: String!
  var participantIdentifiers : [String] = []
  var customSelected: Bool = false
  
  @IBOutlet weak var toFieldBackground: UIView!
  @IBOutlet weak var licensePlateLabel: UILabel!
  @IBOutlet weak var presetTable: UITableView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("NewMessage")
  }
  
  override func viewDidLoad() {
    toFieldBackground.backgroundColor = StyleColor.getColor(.Grey, brightness: .Light)
    licensePlateLabel.text = licensePlate
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
    AnalyticsHelper.trackTouchEvent("send_preset_message")
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! NewMessageTableViewCell
    selectedMessage = cell.label.text!
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    sendMessageToLicensePlate(licensePlateLabel.text!)
  }
  
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    var button = UIButton()
    button.setTitle("Custom", forState: .Normal)
    button.addTarget(self, action: "goToCustomMessage", forControlEvents: UIControlEvents.TouchUpInside)
    button.titleLabel!.font = UIFont.systemFontOfSize(14.0)
    return button
  }
  
  func goToCustomMessage() {
    customSelected = true
    AnalyticsHelper.trackButtonPress("custom_message")
    self.performSegueWithIdentifier("send_to_conversation", sender: self)
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 50.0
  }
  
  func sendMessageToLicensePlate(licensePlate : String) {
    self.performSegueWithIdentifier("send_to_conversation", sender: self)
  }


}

// We have a custom table cell which contains a label, so that we can customize
// the look and positioning of table cells.
class NewMessageTableViewCell : UITableViewCell {
  @IBOutlet weak var label: UILabel!
}
