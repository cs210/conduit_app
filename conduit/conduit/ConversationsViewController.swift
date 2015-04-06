//
//  ConversationsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ConversationsViewController : UIViewController, UITableViewDataSource {
  
  var conversations : [Conversation] = []
  var tappedConversation : Conversation!
  
  var fakeUser : User!
  
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
    self.tableView.rowHeight = 70
    
    
    // TODO: This is fake. Here, we will need to add a real API call to populate
    // the list of conversations.
    
//    var fakePerson = User(firstName:"Bob", lastName:"Smith", id: 1)
//    
//    fakeUser = fakePerson
//    
//    var fakeCar = Car(userIds: [1], licensePlate:"CS210B")
//    conversations = [
//      Conversation(
//        receiverCarId: 2,
//        requesterUserId: 1,
//        requesterUser: fakePerson,
//        messages: [
//            Message(senderId: 1, text: "Hi, for how long are you planning to use your charging station?", timestamp: NSDate()),
//            Message(senderId: 2, text: "Only about five more minutes!", timestamp: NSDate()),
//            Message(senderId: 1, text: "Great, thank you!", timestamp: NSDate())
//          ],
//        isUnread: false
//      ),
//      Conversation(
//        receiverCarId: 3,
//        requesterUserId: 1,
//        requesterUser: fakePerson,
//        messages: [
//          Message(senderId: 1, text: "Hi, for how long are you planning to use your charging station?", timestamp: NSDate()),
//          Message(senderId: 3, text: "Only about five more minutes!", timestamp: NSDate())
//        ],
//        isUnread: true
//      ),
//      Conversation(
//        receiverCarId: 1,
//        requesterUserId: 4,
//        requesterUser: User(firstName: "Kanye", lastName: "West", userId: 4),
//        messages: [
//          Message(senderId: 4, text: "When will you be back to your charging station?", timestamp: NSDate()),
//          Message(senderId: 1, text: "10 mins! Be there soon.", timestamp: NSDate())
//        ],
//        isUnread: false
//      ),
//      Conversation(
//        receiverCarId: 5,
//        receiverCar: Car(userIds:[5], licensePlate:"XYZ123"),
//        requesterUserId: 1,
//        requesterUser: fakePerson,
//        messages: [
//          Message(senderId: 1, text: "Could I please use your charging station?", timestamp: NSDate())
//        ],
//        isUnread: false
//      )
//    ]
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return conversations.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ConversationsListItem", forIndexPath: indexPath) as ConversationsTableViewCell
    
    var conv = conversations[indexPath.row]
    
//    // unread messages are bolded
//    if conv.isUnread == true {
//      cell.licensePlateLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
//      cell.latestMessageLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
//    } else {    // cells are recycled, so we also have to un-bold read messages
//      cell.licensePlateLabel.font = UIFont(name:"HelveticaNeue", size: 16.0)
//      cell.latestMessageLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
//    }
//
//    if conv.receiverCar == nil {
//      // TODO: API call to get receiver car
//    }
//    cell.licensePlateLabel.text = conv.receiverCar.licensePlate
//    
//    if conv.messages.count == 0 {
//      // Error case here?
//    }
//    cell.latestMessageLabel.text = conv.messages[conv.messages.count-1].text
//    
//    let formatter = NSDateFormatter()
//    let usDateFormat = NSDateFormatter.dateFormatFromTemplate("MMddyy", options: 0, locale: NSLocale(localeIdentifier: "en-US"))
//    formatter.dateFormat = usDateFormat
// 
//    cell.dateLabel.text = formatter.stringFromDate(conv.messages[conv.messages.count-1].timestamp)
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Fake
    tappedConversation = conversations[indexPath.row]
    
    // Real
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    performSegueWithIdentifier("conversation_segue", sender: self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "conversation_segue" {
      var next = segue.destinationViewController as MessagesViewController
      
      next.conversation = tappedConversation
      next.fakeUser = fakeUser
    }
  }
  
}

class ConversationsTableViewCell : UITableViewCell {
  @IBOutlet weak var licensePlateLabel: UILabel!
  @IBOutlet weak var latestMessageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
}
