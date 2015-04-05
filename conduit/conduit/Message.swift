//
//  Message.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import SwiftyJSON

class Message: APIModel {
  var text: String
  var timestamp: NSDate
  var conversationId: Int
  var senderId: Int
  
  init(id:Int, text:String, timestamp:NSDate, conversationId:Int, senderId:Int) {
    self.text = text
    self.timestamp = timestamp
    self.conversationId = conversationId
    self.senderId = senderId
    super.init(id: id)
  }
}