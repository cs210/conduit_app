//
//  Conversation.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import SwiftyJSON

class Conversation: APIModel {
  
  var receiverCarID: Int
  var requesterUserID: Int
  var messages: [Message]
  
  init (id: Int, receiverCarID: Int, requesterUserID: Int, messages: [Message]) {
    self.receiverCarID = receiverCarID
    self.requesterUserID = requesterUserID
    self.messages = messages
    super.init(id: id)
  }
  
  convenience init(json: JSON, messages: [Message]) {
   // var messageIDs = Array(json["message_ids"].stringValue) as [Int]
    self.init(
      id:              json["id"].intValue,
      receiverCarID:   json["receiver_car_id"].intValue,
      requesterUserID: json["requester_user_id"].intValue,
      messages:        messages
    )
  }
  
  func description() -> String {
    return "id:\(self.id)\n" +
            "receiverCarID:\(self.receiverCarID)\n" +
            "requesterUserID:\(self.requesterUserID)\n" +
            "messages:\(self.messages)\n"
  }
  
}