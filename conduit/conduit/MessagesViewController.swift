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
  var conversation : Conversation!
  var fakeUser : User!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    // TODO: API call to get conversation information using conversation ID 
    // passed from previous view - for now, faking it.
    super.viewDidLoad()
    
    if fakeUser.userId == conversation.requesterUserId {
      if conversation.receiverCar == nil {
        // TODO: API call
      }
      
      navBar.title = conversation.receiverCar.licensePlate
    } else {
      if conversation.requesterUser == nil {
        // TODO: API call
      }
      
      navBar.title = conversation.requesterUser.firstName
    }
    
    self.tableView.estimatedRowHeight = 44.0
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.reloadData()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : MessageCell!
    if conversation.messages[indexPath.row].senderId == fakeUser.userId {
      cell = tableView.dequeueReusableCellWithIdentifier("SentMessageCell") as MessageCell
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier("ReceivedMessageCell") as MessageCell
    }
    cell.messageText.text = conversation.messages[indexPath.row].text
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return conversation.messages.count
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