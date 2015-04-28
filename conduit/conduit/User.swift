//
//  User.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class User: APIModel, ATLParticipant {

  var firstName             : String
  var lastName              : String
  var fullName              : String
  var phoneNumber           : String
  var emailAddress          : String
  var deviceToken           : String?
  var pushEnabled           : Bool
  var participantIdentifier : String? = nil

  init(id:Int?, firstName:String, lastName:String, phoneNumber:String, emailAddress:String,
    deviceToken:String?, pushEnabled:Bool, participantIdentifier: String?) {

    self.firstName = firstName
    self.lastName = lastName
    self.fullName = "\(firstName) \(lastName)"
    self.phoneNumber = phoneNumber
    self.emailAddress = emailAddress
    self.deviceToken = deviceToken
    self.pushEnabled = pushEnabled
    self.participantIdentifier = participantIdentifier
    super.init(id:id)

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
      pushEnabled:  json["push_enabled"].boolValue,
      participantIdentifier: json["participant_identifier"].stringValue
    )
  }
  
  override func present() -> [String:AnyObject] {
    var present: [String:AnyObject] = [
      "first_name": self.firstName,
      "last_name": self.lastName,
      "phone_number": self.phoneNumber,
      "email_address": self.emailAddress,
      "push_enabled": self.pushEnabled
    ]
    
    if let id = self.id {
      present.updateValue(id, forKey: "id")
    }
    if let participantIdentifier = self.participantIdentifier {
      present.updateValue(participantIdentifier, forKey: "participant_identifier")
    }
    
    if let deviceToken = self.deviceToken {
      present.updateValue(deviceToken, forKey: "device_token")
    }
    
    return present
  }
  
  var avatarImage:UIImage! {
    get {
      return UIImage(named: "DefaultFriendThumbnail")
    }
  }

  
  // pragma mark - NSCoding http://nshipster.com/nscoding/
  
//  required convenience init(coder decoder: NSCoder) {
//    self.init()
//    self.id = decoder.decodeObjectForKey("id") as Int?
//    self.
//    
//  }

}

