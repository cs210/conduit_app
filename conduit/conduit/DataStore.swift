//
//  DataStore.swift
//  conduit
//
//  Created by Nathan Eidelson on 4/21/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation

private let _sharedInstance = DataStore()

let defaultPresetMessages = [
  "I'm low on charge. Could I please use the charging station?",
  "Hi! When will you be back to your car?",
  "Could you please come move your car?"
]

class DataStore {
  
  class var sharedInstance: DataStore {
    return _sharedInstance
  }
  
  class func presetFilePath() -> String {
    
    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let docsDir = dirPaths[0] as! String
    
    var filename = "data"
    if let currentUser = User.getUserFromDefaults() {
      filename = currentUser.emailAddress
    }
    
    var presetFilePath = docsDir.stringByAppendingPathComponent(filename)
    return presetFilePath
  }
  
  func seed() {
    var presetMessages = self.readPresetMessages()
    
    if presetMessages == nil {
      self.writePresetMessages(defaultPresetMessages)
    }
  }
  
  func addPresetMessage(message: String) {
    var presetMessages: [String] = self.readPresetMessages()!
    presetMessages.append(message)
    writePresetMessages(presetMessages)
  }
  
  func readPresetMessages() -> [String]? {
    var file = DataStore.presetFilePath()
    NSLog("Reading presents from \(file)")
    var presetMessages: [String]? = NSArray(contentsOfFile: file) as? [String]
    return presetMessages
  }
  
  func writePresetMessages(messages:[String]) {
    var file = DataStore.presetFilePath()
    NSLog("Writing presents to \(file)")
    NSArray(array: messages).writeToFile(file, atomically: true)
  }

  
}

