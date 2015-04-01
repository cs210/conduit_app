//
//  Message.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation

class Message: APIModel {
  var text: String
  var timestamp: NSDate
  var conversationID: Int
  var senderID: Int
  
  init(text:String, timestamp:NSDate, conversationID:Int, senderID:Int) {
    self.text = text
    self.timestamp = timestamp
    self.conversationID = conversationID
    self.senderID = senderID
  }
}