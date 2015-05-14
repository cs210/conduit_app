//
//  InviteFriendsViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 4/25/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit
import Social

class InviteFriendsViewController : UIViewController {
  
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  @IBOutlet weak var facebookButton: UIButton!
  @IBOutlet weak var twitterButton: UIButton!
  
  
  let HEADER_MESSAGE : String = "The more people are on Conduit, the better " +
                 "experience everyone has, so invite your EV-owning friends!\n " +
                 "Share Conduit on your social media accounts to improve the " +
                 "Conduit experience for everyone."
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Google Analytics
    AnalyticsHelper.trackScreen("InviteFriends")
    
    let facebookLogo = UIImage(named: "FB-f-Logo__blue_144.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal) as UIImage!
    facebookButton.setImage(facebookLogo, forState: .Normal)
    facebookButton.tintColor = nil
    facebookButton.backgroundColor = nil
    
    let twitterLogo = UIImage(named: "Twitter_logo_blue.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal) as UIImage!
    twitterButton.setImage(twitterLogo, forState: .Normal)
    twitterButton.tintColor = nil
    twitterButton.backgroundColor = nil
    
    StyleHelpers.setButtonFont(menuButton)
    StyleHelpers.setButtonFont(doneButton)
  }
  
  override func viewDidLoad() {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    if defaults.boolForKey("isNewAccount") {
      menuButton.hidden = true
    } else {
      menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
      doneButton.hidden = true
    }
    infoLabel.text = HEADER_MESSAGE

    var swipeRight = UISwipeGestureRecognizer(target: self.revealViewController(), action: "revealToggle:")
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    self.view.addGestureRecognizer(swipeRight)
    
  }
  
  // https://stackoverflow.com/questions/27717709/how-to-share-image-on-facebook-using-swift-in-ios
  @IBAction func doFbShare(sender: AnyObject) {
    let facebookPost = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
    facebookPost.completionHandler = {
      result in
      switch result {
      case SLComposeViewControllerResult.Cancelled:
        //Code to deal with it being cancelled
        break
        
      case SLComposeViewControllerResult.Done:
        //Code here to deal with it being completed
        let alertController = UIAlertController(title: "", message:
          "Thank you for sharing Conduit with your friends!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        break
      }
    }
  
    facebookPost.setInitialText("I'm on #Conduit, the best solution for charge rage. Check it out for yourself at") //The default text in the tweet
    facebookPost.addURL(NSURL(string: "http://conduitapp.me")) //A url which takes you into safari if tapped on
    
    self.presentViewController(facebookPost, animated: false, completion: {
      //Optional completion statement
    })
    
  }
  
  @IBAction func doTwitterShare(sender: AnyObject) {
    let twitterPost = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
    twitterPost.completionHandler = {
      result in
      switch result {
      case SLComposeViewControllerResult.Cancelled:
        //Code to deal with it being cancelled
        break
        
      case SLComposeViewControllerResult.Done:
        //Code here to deal with it being completed
        let alertController = UIAlertController(title: "", message:
          "Thank you for sharing Conduit with your friends!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        break
      }
    }
    
    twitterPost.setInitialText("I'm on #Conduit, the best solution for charge rage. Check it out for yourself at") //The default text in the tweet
    twitterPost.addURL(NSURL(string: "http://conduitapp.me")) //A url which takes you into safari if tapped on
    
    self.presentViewController(twitterPost, animated: false, completion: {
      //Optional completion statement
    })
  }
  
  @IBAction func goToScanner(sender: AnyObject) {
    var defaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(false, forKey: "isNewAccount")
    self.navigationController?.dismissViewControllerAnimated(true, completion: {
      
      var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      var revealController : SWRevealViewController = appDelegate.window!.rootViewController as! SWRevealViewController
      var navController : UINavigationController = revealController.frontViewController as! UINavigationController
      
      var licenseInputViewController = navController.topViewController as! LicenseInputController?
      licenseInputViewController?.licenseField.becomeFirstResponder()
      
    })
    
  }
  
}
