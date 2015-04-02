//
//  Message.swift
//  conduit
//
//  Created by Nisha Masharani on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class Message : NSObject {
  let senderId : Int
  let text : String
  let timestamp : NSDate
  
  init(senderId : Int, text : String, timestamp : NSDate) {
    self.senderId = senderId
    self.text = text
    self.timestamp = timestamp
  }
}