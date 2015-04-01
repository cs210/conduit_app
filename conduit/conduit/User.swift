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
  
  // This should be the ONLY place where JSON => attribute mapping occurs
  convenience init(json:JSON) {
    self.init(
      id:           json["id"].intValue,
      firstName:    json["first"].stringValue,
      lastName:     json["last"].stringValue,
      phoneNumber:  json["phone"].stringValue,
      emailAddress: json["email"].stringValue,
      deviceToken:  json["device_token"].stringValue,
      pushEnabled:  json["push_enabled"].boolValue
    )
  }
  
  func description() -> String {
    var str1 = "id:\(self.id) " +
           "firstName:\(self.firstName) " +
           "lastName:\(self.lastName) " +
           "phoneNumber:\(self.phoneNumber) "
    
    var str2 =
           "emailAddress:\(self.emailAddress) " +
           "deviceToken:\(self.deviceToken) " +
           "pushEnable:\(self.pushEnabled) "
    
    return str1 + str2
  }

}

