//
//  AnalyticsHelper.swift
//  conduit
//
//  Created by Nisha Masharani on 5/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import GoogleAnalytics_iOS_SDK

class AnalyticsHelper {
  static let TRACKING_ID : String = "UA-62445439-2"
  
  class func initAnalytics() {
    GAI.sharedInstance().trackUncaughtExceptions = true
    GAI.sharedInstance().dispatchInterval = 20
    GAI.sharedInstance().trackerWithTrackingId(TRACKING_ID)
    GAI.sharedInstance().logger.logLevel = GAILogLevel.None
    GAI.sharedInstance().trackUncaughtExceptions = true
  }
  
  class func trackScreen(name : String) {
    var tracker : GAITracker = GAI.sharedInstance().trackerWithTrackingId(TRACKING_ID)
    let build = GAIDictionaryBuilder.createScreenView().set(name, forKey: kGAIScreenName).build() as NSDictionary
    tracker.send(build as [NSObject : AnyObject])
  }
  
  class func trackButtonPress(label : String) {
    trackEvent("button_press", label: label)
  }
  
  class func trackTouchEvent(label: String) {
    trackEvent("touch_event", label: label)
  }
  
  class func trackEvent(action : String, label : String) {
    var tracker : GAITracker = GAI.sharedInstance().trackerWithTrackingId(TRACKING_ID)
    let build = GAIDictionaryBuilder.createEventWithCategory("ui_action", action: action, label: label, value: nil).build() as NSDictionary
    tracker.send(build as [NSObject : AnyObject])
  }
  
}