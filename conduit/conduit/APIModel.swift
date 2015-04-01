//
//  APIClient.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/18/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let APIURL = "http://0.0.0.0:8080/"

/* Defines a base API model class, which inplements basic REST functionality to any subclass.
   PATH is thus optional. If provided, it is always used. If not, the class of the inheriting 
   object it used. 
  
   Do not include path unless you have a very good reason to do so!
*/

class APIModel {
  
  class func get(path: String? = nil, parameters: [String: AnyObject]? = nil, completion: (result: JSON?, error: NSError?) -> ()){
    var url = ""
    
    if let model = path {
      url = "\(APIURL)\(model)"
    } else {
      var model = NSStringFromClass(self).componentsSeparatedByString(".").last!.lowercaseString + "s"
      url = "\(APIURL)\(model)"
    }
    
    NSLog("Preparing for GET request to: \(url)")
    
    Alamofire.request(.GET, url, parameters: parameters).responseJSON {
      (req, res, json, error) in
      if(error != nil) {
        NSLog("GET Error: \(error)")
      
        completion(result:nil, error:error!)
      } else {
        var json = JSON(json!)
        NSLog("GET Result: \(json)")
  //      json.dynamicType.printClassName()
        
        completion(result:json, error:nil)
      }
    }
  }
  
  class func post(path: String? = nil, parameters: [String: AnyObject]? = nil, completion: (result: JSON?, error: NSError?) -> ()){
    var url = ""

    if let model = path {
      url = "\(APIURL)\(model)"
    } else {
      var model = NSStringFromClass(self).componentsSeparatedByString(".").last!.lowercaseString + "s"
      url = "\(APIURL)\(model)"
    }
    
    NSLog("Preparing for POST request to: \(url)")
    
    Alamofire.request(.POST, url, parameters: parameters).responseJSON {
      (req, res, json, error) in
      if(error != nil) {
        NSLog("POST Error: \(error)")
        
        completion(result:nil, error:error!)
      } else {
        var json = JSON(json!)
        NSLog("POST Result: \(json)")
        
        completion(result:json, error:nil)
      }
    }
  }
  
  // To think about: how do we extend this for an /id? pass as param or include in path?
}
