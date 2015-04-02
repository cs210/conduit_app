// Playground - noun: a place where people can play

import UIKit
import SwiftyJSON

class Conversation {
  
  var id: Int
  var receiverCarID: Int
  var requesterUserID: Int
  var messageIDs: [Int]
  
  init (id: Int, receiverCarID: Int, requesterUserID: Int, messageIDs: [Int]) {
    self.id = id
    self.receiverCarID = receiverCarID
    self.requesterUserID = requesterUserID
    self.messageIDs = messageIDs
  }
  
  convenience init(json:JSON) {
    // var messageIDs = Array(json["message_ids"].stringValue) as [Int]
    self.init(
      id:              json["id"].intValue,
      receiverCarID:   json["receiver_car_id"].intValue,
      requesterUserID: json["requester_user_id"].intValue,
      messageIDs:      [1]
    )
  }
  
  func description() -> String {
    return "id:\(self.id)\n" +
      "receiverCarID:\(self.receiverCarID)\n" +
      "requesterUserID:\(self.requesterUserID)\n" +
    "messageIDs:\(self.messageIDs)\n"
  }
  
}

var json:JSON = ["conversations":["id":2 ,"message_ids":[0,1,2]]]

var conversation_index: NSMutableArray = []
for (index: String, conv: JSON) in json["conversations"] {
  var convo = Conversation(json:conv)
  NSLog(convo.description())

  conversation_index.addObject(
    convo
  )
  
}
