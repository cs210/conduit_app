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

#if arch(i386) || arch(x86_64)
  let APIURL = "http://104.236.149.170:6969/"
#else
  //let APIURL = "http://127.0.0.1:8080/"
  let APIURL = "http://104.236.149.170:6969/"
#endif

// default base url


/* Defines a base API model class, which implements basic REST functionality on any subclass.
   PATH is optional since introspection can determine the model name. If provided, it is always 
   used. If not, the class of the inheriting object it used.
  
   Do not include path unless you have a very good reason to do so!
*/

class APIModel: NSObject {
  
  var id: Int? =  nil
  
  init(id: Int?) {
    self.id = id
  }
  
  // MARK - Class/Type Methods.
  
  class func get(path: String, parameters: [String: AnyObject]? = nil, get_completion: (result: JSON?, error: NSError?) -> ()){
    
    var url = "\(APIURL)\(path)"
                  
    NSLog("Preparing for GET request to: \(url)")
    
    Alamofire.request(.GET, url, parameters: parameters).responseJSON {
      (req, res, json, error) in
      if(error != nil) {
        NSLog("GET Error: \(error)")
        get_completion(result:nil, error:error!)
      } else {
        var json = JSON(json!)
        NSLog("GET Result: \(json)")
        get_completion(result:json, error:nil)
      }
    }
    
  }

  class func post(path: String, parameters: [String: AnyObject]?,
                  post_completion: (result: JSON?, error: NSError?) -> ()){

    var url = "\(APIURL)\(path)"
    
    NSLog("Preparing for POST request to: \(url)")
    Alamofire.request(.POST, url, parameters: parameters, encoding:.JSON).responseJSON {
      (req, res, json, error) in
      if(error != nil) {
        NSLog("POST Error: \(error) \(res)")
        post_completion(result:nil, error:error!)
      } else {
        var json = JSON(json!)
        NSLog("POST Result: \(json)")
        post_completion(result:json, error:nil)
      }
    }
  }
  
  class func put(path: String, parameters: [String: AnyObject]?,
    put_completion: (result: JSON?, error: NSError?) -> ()){
      
      var url = "\(APIURL)\(path)"
      
      NSLog("Preparing for PUT request to: \(url)")
      Alamofire.request(.PUT, url, parameters: parameters, encoding:.JSON).responseJSON {
        (req, res, json, error) in
        if(error != nil) {
          NSLog("PUT Error: \(error) \(res)")
          put_completion(result:nil, error:error!)
        } else {
          var json = JSON(json!)
          NSLog("PUT Result: \(json)")
          put_completion(result:json, error:nil)
        }
      }
  }
  
  class func delete(path: String, parameters: [String: AnyObject]?,
    delete_completion: (result: JSON?, error: NSError?) -> ()){
      
      var url = "\(APIURL)\(path)"
      
      NSLog("Preparing for DELETE request to: \(url)")
      
      Alamofire.request(.DELETE, url, parameters: parameters, encoding:.JSON).responseJSON {
        (req, res, json, error) in
        if(error != nil) {
          NSLog("DELETE Error: \(error) \(res)")
          delete_completion(result:nil, error:error!)
        } else {
          var json = JSON(json!)
          NSLog("DELETE Result: \(json)")
          delete_completion(result:json, error:nil)
        }
      }
  }
  
  
  
  class func index(completion: (result: JSON?, error: NSError?) -> ()){
    self.get("\(self.model())", get_completion:({ (result: JSON?, error: NSError?) in
      completion(result: result, error: error)
    }))
  }
  
  // MARK - Instance Methods.
  
  func update(completion: (result: JSON?, error: NSError?) -> ()){
    var path = "\(self.model())/\(self.id)"
    APIModel.put(path, parameters: self.present()) { (result, error) -> () in
      if (error != nil) {
        completion(result: nil, error: error!)
      } else {
        completion(result: result, error: nil)
      }
    }
  }
  
  func delete(completion: (result: JSON?, error: NSError?) -> ()){
    var path = "\(self.model())/\(self.id)"
    APIModel.delete(path, parameters: self.present()) { (result, error) -> () in
      if (error != nil) {
        completion(result: nil, error: error!)
      } else {
        completion(result: result, error: nil)
      }
    }
  }
  
  func present() -> [String:AnyObject] {
      // to be overwritten
    return [:]
  }
  
  // For Classes. e.g. User.model() = "users"
  class func model() -> String {
    return NSStringFromClass(self).componentsSeparatedByString(".").last!.lowercaseString + "s"
  }
  
  // For Instances. e.g. user.model() = "users"
  func model() -> String {
    return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!.lowercaseString + "s"
  }
  
}
