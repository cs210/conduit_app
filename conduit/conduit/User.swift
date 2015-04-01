//
//  User.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: APIModel {

  var id          : Int
  var firstName   : String
  var lastName    : String
  var phoneNumber : String
  var emailAddress: String
  var deviceToken : String
  var pushEnabled : Bool
  
  
  init(id:Int, firstName:String, lastName:String, phoneNumber:String, emailAddress:String,
       deviceToken:String, pushEnabled:Bool) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.phoneNumber = phoneNumber
    self.emailAddress = emailAddress
    self.deviceToken = deviceToken
    self.pushEnabled = pushEnabled
  }


}

