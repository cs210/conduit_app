//
//  ConversationListViewController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit
//import SwiftyJSON


class ConversationListViewController : ATLConversationListViewController, ATLConversationListViewControllerDataSource, ATLConversationListViewControllerDelegate, SWRevealViewControllerDelegate {

  var selectedIndex: NSIndexPath!
  var dateFormatter: NSDateFormatter!
  
  @IBOutlet weak var menuButton: UIBarButtonItem!
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ConversationsList")
    menuButton.setTitleTextAttributes([NSFontAttributeName : UIFont(name: StyleHelpers.FONT_NAME, size: StyleHelpers.FONT_SIZE)!, NSForegroundColorAttributeName : TextColor.getTextColor(.Light)], forState: .Normal)
    
  }
  
  // The conversation view controllers uses this to start new conversations
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dataSource = self
    self.delegate   = self
    
    // Setup the dateformatter used by the dataSource.
    self.dateFormatter = NSDateFormatter()
    self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
    self.navigationController?.navigationBar.topItem?.title = "Conversations"
    StyleHelpers.setBackButton(self.navigationItem, label: "Back")
    
    // Setup reveal view controller
    self.revealViewController().delegate = self
    var swipeRight = UISwipeGestureRecognizer(target: self.revealViewController(), action: "revealToggle:")
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    self.view.addGestureRecognizer(swipeRight)
    
    self.configureAppearance()

  }
  
  func configureAppearance() {
    ATLConversationTableViewCell.appearance().conversationTitleLabelFont = UIFont(name:StyleHelpers.FONT_NAME, size:17.0)
    ATLConversationTableViewCell.appearance().lastMessageLabelFont = UIFont(name:StyleHelpers.FONT_NAME, size:15.0)
    ATLConversationTableViewCell.appearance().dateLabelFont = UIFont(name:StyleHelpers.FONT_NAME, size:15.0)
    ATLConversationTableViewCell.appearance().unreadMessageIndicatorBackgroundColor = StyleColor.getColor(.Primary, brightness: .Light)
  }
  
  @IBAction func menuPressed(sender: AnyObject) {
    self.revealViewController().revealToggle(self)
  }
  
  func revealController(revealController: SWRevealViewController!,  willMoveToPosition position: FrontViewPosition){
    if(position == FrontViewPosition.Left) {
      self.view.userInteractionEnabled = true
    } else {
      self.view.userInteractionEnabled = false
    }
  }
  
  func revealController(revealController: SWRevealViewController!,  didMoveToPosition position: FrontViewPosition){
    if(position == FrontViewPosition.Left) {
      self.view.userInteractionEnabled = true
    } else {
      self.view.userInteractionEnabled = false
    }
  }


}

extension ConversationListViewController: ATLConversationListViewControllerDataSource {
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, titleForConversation conversation: LYRConversation!) -> String! {

    var cars: [Car] = Car.getCarsFromDefaults()!
  
    if let licensePlate = conversation.metadata["license_plate"] as? String {
      if let requesterName = conversation.metadata["requester_name"] as? String {
        for car in cars {
          if car.licensePlate == licensePlate {
            return "From: " + requesterName
          }
        }
        return "To: " + licensePlate
      }
    }
    return "Request"
  }
  
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, avatarItemForConversation conversation: LYRConversation!) -> ATLAvatarItem! {
    return User(id: 1, firstName: "FirstName", lastName: "LastName", phoneNumber: "xx", emailAddress: "xx",
      deviceToken: "xx", pushEnabled: true)
  }
  
}

extension ConversationListViewController: ATLConversationListViewControllerDelegate {
  
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didSelectConversation conversation: LYRConversation!) {
    AnalyticsHelper.trackTouchEvent("view_conversation")
    var conversationTitle = self.conversationListViewController(conversationListViewController, titleForConversation: conversation)
    let vc = ConversationViewController(layerClient: self.layerClient)
    
    vc.conversation = conversation
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didDeleteConversation conversation: LYRConversation!, deletionMode:LYRDeletionMode!)
  {
    AnalyticsHelper.trackTouchEvent("deleted_conversation")
    println("Conversation deleted")
  }
  
  func conversationListViewController(conversationListViewController: ATLConversationListViewController, didFailDeletingConversation conversation: LYRConversation!, deletionMode:LYRDeletionMode!, error:NSError!)
  {
    println("Failed to delete conversation with error: \(error)")
  }
  
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didSearchForText searchText: String!, completion: ((Set<NSObject>!) -> Void)!) {
    println("Searching for text: \(searchText)");
    // Does nothing
  }
}

