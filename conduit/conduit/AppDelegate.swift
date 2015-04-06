//
//  AppDelegate.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/3/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var layerClient: LYRClient?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
   
    
    var appID =  NSUUID(UUIDString: "7b2aed30-db1b-11e4-a21a-52bb02000413")
    self.layerClient = LYRClient(appID: appID)
    
    
    
    self.layerClient?.connectWithCompletion({ (success:Bool, error:NSError!) -> Void in
      if (!success) {
        NSLog("Failed to connect to Layer: \(error)");
      } else {
        // TODO: This should be a UUID of the user!
        var userIDString: String = "Device"
        
        LayerHelpers.authenticateLayerWithUserID(userIDString, client: self.layerClient, completion: { (success:Bool, error:NSError!) -> Void in
          
          if (!success) {
            NSLog("Failed Authenticating Layer Client with error:\(error)");
          }
          
        })
        
      }
      
      
    })
    
    return true
  }

  
//  func authenticateLayerWithUserID(userID: String, completion: ((success: Bool, error: NSError?) -> ())? = nil) {
//    
//    // Check to see if the layerClient is already authenticated.
//    if (self.layerClient?.authenticatedUserID != nil) {
//      // If the layerClient is authenticated with the requested userID, complete the authentication process.
//      if (self.layerClient?.authenticatedUserID == userID) {
//        NSLog("Layer Authenticated as User \(self.layerClient?.authenticatedUserID)")
//        if (completion != nil) {
//          completion!(success:true, error:nil)
//        }
//      } else {
//        //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
//        self.layerClient?.deauthenticateWithCompletion({ (success:Bool, error:NSError!) -> Void in
//          if (error == nil) {
//            self.authenticationTokenWithUserId
//            completion?(success: success, error: error))
//          } else {
//            completion?(success: false, error: error))
//          }
//        })
//        
//      }
//      
//    } else {
//      
//    }
//    
//  }


//  func authenticationTokenWithUserId(userID: String, completion: ((success: Bool, error: NSError?) -> ())? = nil) {
//  
//    /*
//    * 1. Request an authentication Nonce from Layer
//    */
//    self.layerClient?.requestAuthenticationNonceWithCompletion({ (nonce:String!, error:NSError!) -> Void in
//      if (nonce != nil) {
//        completion?(false, error)
//        return
//      }
//      
//      self.requestIdentityTokenForUserID
//      
//      
//    })
// 
//    
//  }

//  func requestIdentityTokenForUserID(userID: String!, appID: String!, nonce: String!, completion: ((identityToken: String, error: NSError?) -> ())!) {
//    
//    var identityTokenURL: NSURL = NSURL(string: "https://layer-identity-provider.herokuapp.com/identity_tokens")
//    
//    var request : NSMutableURLRequest = NSMutableURLRequest(URL: identityTokenURL)
//    request.HTTPMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue("application/json", forHTTPHeaderField: "Accept")
//    
//    var parameters = ["p_id": appID, "user_id": userID, "nonce": nonce]
//    
//    var requestBody = NSJSONSerialization.dataWithJSONObject(parameters, options: 0, error: nil)
//    request.HTTPBody = requestBody
//    
//    var sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
//    var session = NSURLSession(configuration: sessionConfiguration)
//    
//    session.dataTaskWithRequest(request: NSURLRequest) { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
//      
//      if (error != nil) {
//        completion(identityToken:nil, error:error)
//        return;
//      }
//      
//      var response
//      
//      
//      
//    }
//    
//
//  }
  
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

