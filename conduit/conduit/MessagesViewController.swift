//
//  MessagesViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class MessagesViewController : UIViewController, UITableViewDataSource {
  @IBOutlet weak var navBar: UINavigationItem!
  var conversationID : Int!
  var fakeLicensePlate : String!
  var fakeMessages = [
    FakeMessage(messageText: "Hi, for how long are you going to be using the charging station?", iAmSender: true),
    FakeMessage(messageText: "Only about ten more minutes. Be there soon!", iAmSender: false),
    FakeMessage(messageText: "Awesome, thank you so much!", iAmSender: true)
  ]
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    // TODO: API call to get conversation information using conversation ID 
    // passed from previous view - for now, faking it.
    super.viewDidLoad()
    navBar.title = fakeLicensePlate
    self.tableView.estimatedRowHeight = 44.0
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.reloadData()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MessageTableCell") as MessageCell
    cell.messageText.text = fakeMessages[indexPath.row].messageText
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fakeMessages.count
  }

}

class MessageCell : UITableViewCell {
  @IBOutlet weak var messageText: UILabel!
}

class FakeMessage {
  var messageText : String!
  var iAmSender : Bool!
  // true if I sent the message, false if the other guy sent it
  
  init(messageText : String, iAmSender : Bool) {
    self.messageText = messageText
    self.iAmSender = iAmSender
  }
}