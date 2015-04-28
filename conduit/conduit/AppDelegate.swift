//
//  AppDelegate.swift
//  conduit
//
//  Created by Nathan Eidelson on 3/3/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

#if arch(i386) || arch(x86_64)
  let LQSCurrentUserID = "Simulator"
  let LQSParticipantUserID = "Device"
  let LQSInitialMessageTexta = "Hey Device! This is your friend, Simulator."
#else
  let LQSCurrentUserID = "Device"
  let LQSParticipantUserID = "Simulator"
  let LQSInitialMessageTexta = "Hey Simulator! This is your friend, Device."
#endif
  let LQSParticipant2UserID = "Dashboard"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LYRClientDelegate {
  
  let LQSLayerAppIDString = "7b2aed30-db1b-11e4-a21a-52bb02000413"
  
  var window: UIWindow?
  var layerClient: LYRClient?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    self.initAppearance()
    
    var appID =  NSUUID(UUIDString: LQSLayerAppIDString)
    self.layerClient = LYRClient(appID: appID)
    self.layerClient?.delegate = self
    
    self.registerApplicationForPushNotifications(application)
    
    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    
    return true
  }
  
  func authenticateWithLayer() {
    
    self.layerClient?.connectWithCompletion({ (success:Bool, error:NSError!) -> Void in
      if (!success) {
        NSLog("Failed to connect to Layer: \(error)");
      } else {
        // TODO: This should be a UUID of the user!
        
        LayerHelpers.authenticateLayerWithUserID(LQSCurrentUserID, client: self.layerClient, completion: { (success:Bool, error:NSError!) -> Void in
          if (!success) {
            NSLog("Failed Authenticating Layer Client with error:\(error)");
          }
        })
      }
      
    })
  }
  
  func initAppearance () {
    UINavigationBar.appearance().backgroundColor = StyleColor.getColor(.Primary, brightness: .Medium)
    UINavigationBar.appearance().barTintColor = StyleColor.getColor(.Primary, brightness: .Medium)
    UINavigationBar.appearance().translucent = false
    
    UINavigationBar.appearance().tintColor = TextColor.getTextColor(.Light)
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : TextColor.getTextColor(.Light)]
    
    UIButton.appearance().backgroundColor = StyleColor.getColor(.Primary, brightness: .Medium)
    UIButton.appearance().tintColor = TextColor.getTextColor(.Light)
    
    UITableView.appearance().backgroundColor = StyleColor.getColor(.Grey, brightness: .Light)
    UITableView.appearance().separatorStyle = .None
    
    UITableViewCell.appearance().layer.borderWidth = 2
    UITableViewCell.appearance().layer.borderColor = StyleColor.getColor(.Grey, brightness: .Light).CGColor
  
    UILabel.appearance().textColor = TextColor.getTextColor(.Dark)
    
    
  }

  func registerApplicationForPushNotifications(application: UIApplication) {
    if (application.respondsToSelector(Selector("registerForRemoteNotifications"))) {
      //ios 8
      var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
      var setting = UIUserNotificationSettings(forTypes: type, categories: nil);
      UIApplication.sharedApplication().registerUserNotificationSettings(setting);
      UIApplication.sharedApplication().registerForRemoteNotifications();
    } else {
      application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound)
    }
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    // Send device token to Layer so Layer can send pushes to this device.
    // For more information about Push, check out:
    // https://developer.layer.com/docs/guides/ios#push-notification
    
    var error: NSError?
    
    var success = self.layerClient?.updateRemoteNotificationDeviceToken(deviceToken, error: &error)
    if (success != nil) {
      NSLog("Application did register for remote notifications: \(deviceToken)");
      NSUserDefaults.standardUserDefaults().setValue(deviceToken, forKey: "deviceToken");
    } else {
      NSLog("Failed updating device token with error: \(error)");
    }
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    // Delegate directly to the LayerHelper class function
    LayerHelpers.application(application, didReceiveRemoteNotification: userInfo, client: self.layerClient, fetchCompletionHandler: completionHandler)
  }
  
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

  // MARK -- LYRClientDelegate Delegate Methods

  func layerClient(client: LYRClient!, didAuthenticateAsUserID userID: String!) {
    NSLog("Layer Client did recieve authentication nonce");
  }
  
  func layerClient(client: LYRClient!, didFailOperationWithError error: NSError!) {
    NSLog("Layer Client did fail operation with error: \(error)");
  }
  
  func layerClient(client: LYRClient!, didFailSynchronizationWithError error: NSError!) {
    NSLog("Layer Client did fail synchronization with error: \(error)");
  }

  
  func layerClient(client: LYRClient!, didFinishSynchronizationWithChanges changes: [AnyObject]!) {
    NSLog("Layer Client did finish sychronization");
  }
  
  func layerClient(client: LYRClient!, didLoseConnectionWithError error: NSError!) {
    NSLog("Layer Client did lose connection with error: \(error)");
  }
  
  func layerClient(client: LYRClient!, didReceiveAuthenticationChallengeWithNonce nonce: String!) {
    NSLog("Layer Client did recieve authentication challenge with nonce: \(nonce)");
  }
  
  func layerClient(client: LYRClient!, willAttemptToConnect attemptNumber: UInt, afterDelay delayInterval: NSTimeInterval, maximumNumberOfAttempts attemptLimit: UInt) {
    NSLog("Layer Client will attempt to connect");
  }
  
  func layerClient(client: LYRClient!, willBeginContentTransfer contentTransferType: LYRContentTransferType, ofObject object: AnyObject!, withProgress progress: LYRProgress!) {
  }
  
  func layerClientDidConnect(client: LYRClient!) {
    NSLog("Layer Client did connect");
  }
  
  func layerClientDidDeauthenticate(client: LYRClient!) {
    NSLog("Layer Client did deauthenticate");
  }
  
  func layerClientDidDisconnect(client: LYRClient!) {
    NSLog("Layer Client did disconnect");
  }

}

