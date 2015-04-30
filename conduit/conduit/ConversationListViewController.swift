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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dataSource = self
    self.delegate   = self
    
    // Setup the dateformatter used by the dataSource.
    self.dateFormatter = NSDateFormatter()
    self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
//    var user1 = User(id: 1, firstName: "FirstName", lastName: "LastName", phoneNumber: "xx", emailAddress: "xx",
//      deviceToken: "xx", pushEnabled: true, participantIdentifier: LQSCurrentUserID)
//
//    var user2 = User(id: 2, firstName: "FirstName2", lastName: "LastName2", phoneNumber: "xx", emailAddress: "xx",
//      deviceToken: "xx", pushEnabled: true, participantIdentifier: LQSParticipantUserID)
//
//    DataStore.sharedInstance.persistUsers(Set([user1, user2]))
//    
    self.navigationController?.navigationBar.topItem?.title = "Conversations"
  }
  
  @IBAction func menuPressed(sender: AnyObject) {
    self.revealViewController().revealToggle(self)
  }
}

//  @IBAction func deleteAllPressed(sender: AnyObject) {
//    
//    var count: UInt = self.queryController.numberOfObjectsInSection(UInt(0))
//    var countAsInt: Int = Int(count)
//    
//    for var row = 0; row < countAsInt; row++ {
//        
//      var indexPath = NSIndexPath(forRow: row, inSection: 0)
//      var conversation: LYRConversation = self.queryController.objectAtIndexPath(indexPath) as! LYRConversation
//        
//      var error:NSError? = NSError()
//      var success = conversation.delete(LYRDeletionMode.AllParticipants, error: &error)
//      if (!success) {
//        NSLog("Conversation deletion erorr: \(error)")
//      }
//        
//    }
//  }



extension ConversationListViewController: ATLConversationListViewControllerDataSource {
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, titleForConversation conversation: LYRConversation!) -> String! {
    if self.layerClient.authenticatedUserID == nil
    {
      return "Not auth'd";
    }
    
    var participants:Set<String> = conversation.participants as! Set<String>
  //  participants = participants.subtract([User.getUserFromDefaults()?.participantIdentifier]!)
    
    var conversationName: String = ""
    for participant in participants {
      conversationName += participant
    }
    
    // TODO: Return the name of the conversation
    return conversationName
  }
  
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, avatarItemForConversation conversation: LYRConversation!) -> ATLAvatarItem! {
    return User(id: 1, firstName: "FirstName", lastName: "LastName", phoneNumber: "xx", emailAddress: "xx",
      deviceToken: "xx", pushEnabled: true, participantIdentifier: "blah")
  }
  
}

extension ConversationListViewController: ATLConversationListViewControllerDelegate {
  
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didSelectConversation conversation: LYRConversation!) {
    var conversationTitle = self.conversationListViewController(conversationListViewController, titleForConversation: conversation)
    let vc = ConversationViewController(layerClient: self.layerClient)
    
    vc.conversationTitle = conversationTitle
    vc.conversation = conversation
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didDeleteConversation conversation: LYRConversation!, deletionMode:LYRDeletionMode!)
  {
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

