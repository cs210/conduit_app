
//
//  User.swift
//  conduit
//
//  Created by Nisha Masharani on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class User : NSObject{
  var firstName : String
  var lastName : String
  var userId : Int
  
  init (firstName:String, lastName:String, userId : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.userId = userId
  }
}