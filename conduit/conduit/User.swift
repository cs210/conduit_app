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

class User: APIModel, ATLParticipant, NSCoding {

  // Note: sessionToken should not be stored on the User since it's not an attribute on the server.
  
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
  
  required convenience init(coder decoder: NSCoder) {
    var dId = decoder.decodeIntegerForKey("id")
    var dFirstName : String = decoder.decodeObjectForKey("firstName") as! String
    var dLastName : String = decoder.decodeObjectForKey("lastName") as! String
    var dFullName : String = decoder.decodeObjectForKey("fullName") as! String
    var dPhoneNumber : String = decoder.decodeObjectForKey("phoneNumber") as! String
    var dEmailAddress : String = decoder.decodeObjectForKey("emailAddress") as! String
    var dDeviceToken : String? = decoder.decodeObjectForKey("deviceToken") as! String?
    var dPushEnabled : Bool = decoder.decodeBoolForKey("pushEnabled")
    var dParticipantIdentifier : String? = decoder.decodeObjectForKey("participantIdentifier") as! String?
    
    self.init(id: dId, firstName: dFirstName, lastName: dLastName, phoneNumber: dPhoneNumber,
      emailAddress: dEmailAddress, deviceToken: dDeviceToken, pushEnabled: dPushEnabled,
      participantIdentifier: dParticipantIdentifier)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    if self.id != nil {
      coder.encodeInteger(self.id!, forKey:"id")
    }
    coder.encodeObject(self.firstName, forKey:"firstName")
    coder.encodeObject(self.lastName, forKey:"lastName")
    coder.encodeObject(self.fullName, forKey:"fullName")
    coder.encodeObject(self.phoneNumber, forKey:"phoneNumber")
    coder.encodeObject(self.emailAddress, forKey:"emailAddress")
    if self.deviceToken != nil {
      coder.encodeObject(self.deviceToken!,  forKey:"deviceToken")
    }
    coder.encodeBool(self.pushEnabled, forKey: "pushEnabled")
    if self.participantIdentifier != nil {
      coder.encodeObject(self.participantIdentifier, forKey:"participantIdentifier")
    }
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
  
  override func update(completion: (result: JSON?, error: NSError?) -> ()){
    var sessionToken = NSUserDefaults().stringForKey("session")
    var path = "users/\(sessionToken!)/update"
    APIModel.post(path, parameters: self.present()) { (result, error) -> () in
      NSLog ("/update POST complete")
    }
  }
  
  var avatarImage:UIImage! {
    get {
      return UIImage(named: "DefaultFriendThumbnail")
    }
  }

  class func getUserFromDefaults() -> User? {
    var sessionToken = NSUserDefaults().stringForKey("session")
    var user : User
    if let data = NSUserDefaults().objectForKey("user") as? NSData {
      return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! User
    }
    return nil
  }
  
  // pragma mark - NSCoding http://nshipster.com/nscoding/
  
//  required convenience init(coder decoder: NSCoder) {
//    self.init()
//    self.id = decoder.decodeObjectForKey("id") as Int?
//    self.
//    
//  }

}

