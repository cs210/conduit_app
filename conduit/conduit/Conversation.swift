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
  
//  var receiverCarId: Int
//  var requesterUserId: Int
//  var messageIds: [Int]
//  
//  init (id: Int, receiverCarId: Int, requesterUserId: Int, requesterUser: User messages: [Message]) {
//    self.receiverCarId = receiverCarId
//    self.requesterUserId = requesterUserId
//    self.requesterUser = requesterUser
//    self.messages = messages
//    super.init(id: id)
//  }
//  
//  // Messages should probably be lazily loaded, but then saved on the conversation.
//  convenience init(json: JSON, messages: [Message]? = nil) {
//   // var messageIds = Array(json["message_ids"].stringValue) as [Int]
//    self.init(
//      id:              json["id"].intValue,
//      receiverCarID:   json["receiver_car_id"].intValue,
//      requesterUserID: json["requester_user_id"].intValue,
//      requesterUser:   json[""]
//      messages:        messages
//    )
//  }
//  
//  func description() -> String {
//    return "id:\(self.id)\n" +
//            "receiverCarID:\(self.receiverCarID)\n" +
//            "requesterUserID:\(self.requesterUserID)\n" +
//            "requesterUser:\(requesterUser)\n" +
//            "messages:\(self.messages)\n"
//  }
//  
}