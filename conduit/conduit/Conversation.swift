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
  var carID: Int
  var senderID: Int
  var messageIDs: [Int]
  
  init (id: Int, carID: Int, senderID: Int, messageIDs: [Int]) {
    self.id = id
    self.carID = carID
    self.senderID = senderID
    self.messageIDs = messageIDs
  }
}