//
//  WelcomeViewController.swift
//  conduit
//
//  Created by Nathan Eidelson on 4/27/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController : UIViewController {
  
  @IBOutlet weak var addCarButton: UIButton!
  @IBOutlet weak var notNowButton: UIButton!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("Welcome")
    StyleHelpers.setButtonFont(addCarButton)
    StyleHelpers.setButtonFont(notNowButton)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  @IBAction func goToScanner(sender: AnyObject) {
    AnalyticsHelper.trackButtonPress("new_user_add_car")
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    var destViewController : AddCarViewController = mainStoryboard.instantiateViewControllerWithIdentifier("addCarView") as! AddCarViewController
    self.navigationController?.pushViewController(destViewController, animated: true)
  }
  
  
  @IBAction func goToInviteFriends(sender: AnyObject) {
    AnalyticsHelper.trackButtonPress("new_user_invite_friends")
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let destViewController : InviteFriendsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("inviteFriendsView") as! InviteFriendsViewController
    self.navigationController?.pushViewController(destViewController, animated: true)
  }
  
}