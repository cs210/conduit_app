//
//  ConversationListViewController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class ConversationListViewController : ATLConversationListViewController, ATLConversationListViewControllerDataSource, ATLConversationListViewControllerDelegate {

  var selectedIndex: NSIndexPath!
  var dateFormatter: NSDateFormatter!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    AnalyticsHelper.trackScreen("ConversationsList")
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

  }
  
  @IBAction func menuPressed(sender: AnyObject) {
    self.revealViewController().revealToggle(self)
  }

}

extension ConversationListViewController: ATLConversationListViewControllerDataSource {
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, titleForConversation conversation: LYRConversation!) -> String! {
    
    var participants:Set<String> = conversation.participants as! Set<String>
    var currentUser: String = User.getUserFromDefaults()!.participantIdentifier

    participants = participants.subtract([currentUser])
    
    var conversationName: String = ""
    for participant in participants {
      conversationName += participant
    }
    
    // TODO: Return the name of the conversation
    return conversationName
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
    
    vc.conversationTitle = conversationTitle
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

