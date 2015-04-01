//
//  Conversation.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation

class Conversation: APIModel {
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
}