//
//  Conversation.swift
//  conduit
//
//  Created by Nisha Masharani on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class Conversation : NSObject {
  let receiverCarId : Int
  let receiverCar : Car!
  let requesterUserId : Int
  let requesterUser : User!
  var messages : [Message]
  var isUnread : Bool
  
  init(receiverCarId : Int, requesterUserId : Int, messages : [Message], isUnread : Bool) {
    self.receiverCarId = receiverCarId
    self.requesterUserId = requesterUserId
    self.messages = messages
    self.isUnread = isUnread
    self.receiverCar = nil
    self.requesterUser = nil
  }
  
  init(receiverCarId : Int, receiverCar : Car, requesterUserId : Int, requesterUser : User, messages : [Message], isUnread : Bool) {
    self.receiverCarId = receiverCarId
    self.requesterUserId = requesterUserId
    self.messages = messages
    self.isUnread = isUnread
    self.receiverCar = receiverCar
    self.requesterUser = requesterUser
  }
}
