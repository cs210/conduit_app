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
  class func trackScreen(name : String) {
    var tracker : GAITracker = GAI.sharedInstance().trackerWithTrackingId("UA-62445439-2")
    let build = GAIDictionaryBuilder.createScreenView().set(name, forKey: kGAIScreenName).build() as NSDictionary
    tracker.send(build as [NSObject : AnyObject])
  }
}