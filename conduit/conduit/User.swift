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

  var firstName   : String
  var lastName    : String
  var phoneNumber : String
  var emailAddress: String
  var deviceToken : String
  var pushEnabled : Bool
  
  init(id:Int, firstName:String, lastName:String, phoneNumber:String, emailAddress:String,
       deviceToken:String, pushEnabled:Bool) {
    self.firstName = firstName
    self.lastName = lastName
    self.phoneNumber = phoneNumber
    self.emailAddress = emailAddress
    self.deviceToken = deviceToken
    self.pushEnabled = pushEnabled
    super.init(id: id)
  }
  
  // init/present are the ONLY two functions where JSON => attribute mapping occurs
  convenience init(json:JSON) {
    self.init(
      id:           json["id"].intValue,
      firstName:    json["first_name"].stringValue,
      lastName:     json["last_name"].stringValue,
      phoneNumber:  json["phone_number"].stringValue,
      emailAddress: json["email_address"].stringValue,
      deviceToken:  json["device_token"].stringValue,
      pushEnabled:  json["push_enabled"].boolValue
    )
  }
  
  override func present() -> [String:AnyObject] {
    return [
      "id": self.id,
      "first_name": self.firstName,
      "last_name": self.lastName,
      "phone_number": self.phoneNumber,
      "email_address": self.emailAddress,
      "device_token": self.deviceToken,
      "push_enabled": self.pushEnabled
    ]
  }
  
  func description() -> String {
    var str1 = "id:\(self.id)\n" +
           "firstName:\(self.firstName)\n" +
           "lastName:\(self.lastName)\n" +
           "phoneNumber:\(self.phoneNumber)\n"
    var str2 =
           "emailAddress:\(self.emailAddress)\n" +
           "deviceToken:\(self.deviceToken)\n" +
           "pushEnable:\(self.pushEnabled)\n"
    
    return str1 + str2
  }
  


}

