//
//  DataStore.swift
//  conduit
//
//  Created by Nathan Eidelson on 4/21/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation

private let _sharedInstance = DataStore()

class DataStore {
  
  class var sharedInstance: DataStore {
    return _sharedInstance
  }
  
  var users: Set<User>?
  
  func persistUsers(users: Set<User>) {
    self.users = users
  }
  
  func userForIdentifier(identifer: String) -> User? {

    if let users = self.users {
      for user in users {
        if user.participantIdentifier == identifer {
          return user
        }
      }
    }
    
    return nil

  }
  
  
}