//
//  ConversationViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit


class ConversationViewController : ATLConversationViewController {
  
  var dateFormatter: NSDateFormatter!
  var participantIdentifiers: [String]?
  var licensePlate: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.dataSource = self
    self.delegate   = self
    
    // Setup the dateformatter used by the dataSource.
    self.dateFormatter = NSDateFormatter()
    self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
    self.configureUIColors()
    
    self.messageInputToolbar.leftAccessoryButton = nil
    self.messageInputToolbar.displaysRightAccessoryImage = false
    self.messageInputToolbar.rightAccessoryButton.setTitleColor(StyleColor.getColor(.Primary, brightness: .Medium), forState:.Normal)
    self.messageInputToolbar.rightAccessoryButton.backgroundColor = nil
    
  }
  
  override func viewWillAppear(animated: Bool) {
    var title: String = ""
    if conversation != nil {
      if let license_plate = conversation.metadata["license_plate"] as? String {
        title = license_plate
      }
    }
    self.navigationItem.title = title
    AnalyticsHelper.trackScreen("Conversation")
  }
  
  
  func sendInitMessage(messageText: String, licensePlate: String) {
    // If no conversations exist, create a new conversation object with a single participant
    if (self.conversation == nil) {
      var error:NSError? = nil
      self.conversation = self.layerClient.newConversationWithParticipants(
        NSSet(array: self.participantIdentifiers!) as Set<NSObject>, options: nil, error: &error
      )
      self.conversation.setValue(licensePlate, forMetadataAtKeyPath: "license_plate")
      
      if (self.conversation == nil) {
        NSLog("New Conversation creation failed: \(error)")
      }
    }
    
    if messageText == "" {
      NSLog("Empty conversation created")
      return
    }
    
    var messagePart: LYRMessagePart = LYRMessagePart(text: messageText)
    var pushMessage: String = "\(self.layerClient.authenticatedUserID) says \(messageText)"
    var message: LYRMessage = self.layerClient.newMessageWithParts([messagePart], options: [LYRMessageOptionsPushNotificationAlertKey: pushMessage], error: nil)
    
    // Send message
    var error:NSError? = nil
    
    var success:Bool = self.conversation.sendMessage(message, error:&error)
    if (success) {
      NSLog("Message queued to be sent: \(messageText)");
    } else {
      NSLog("Message send failed: \(error)");
    }
    
  }
 
  func configureUIColors () {
    ATLIncomingMessageCollectionViewCell.appearance().bubbleViewCornerRadius = 10

    ATLIncomingMessageCollectionViewCell.appearance().bubbleViewColor = ATLLightGrayColor()
    ATLIncomingMessageCollectionViewCell.appearance().messageTextColor = TextColor.getTextColor(.Dark)
    ATLIncomingMessageCollectionViewCell.appearance().messageLinkTextColor = StyleColor.getColor(.Secondary, brightness:.Dark)
    
    ATLOutgoingMessageCollectionViewCell.appearance().bubbleViewCornerRadius = 10
    ATLOutgoingMessageCollectionViewCell.appearance().bubbleViewColor = StyleColor.getColor(.Primary, brightness: .Light)
    ATLOutgoingMessageCollectionViewCell.appearance().messageTextColor = UIColor.whiteColor()
    ATLOutgoingMessageCollectionViewCell.appearance().messageLinkTextColor = UIColor.whiteColor()
    
    ATLMessageInputToolbar.appearance().tintColor = TextColor.getTextColor(.Dark)
//    applyConversationAppearance()
  }
  
//  func applyConversationAppearance() {
//    UIButton.appearance().tintColor = TextColor.getTextColor(.Dark)
//    UIButton.appearance().backgroundColor = UIColor.whiteColor()
//  }
//  
//  func resetGlobalAppearance() {
//    UIButton.appearance().tintColor = TextColor.getTextColor(.Light)
//    UIButton.appearance().backgroundColor = StyleColor.getColor(.Primary, brightness: .Medium)
//  }
//  
}

extension ConversationViewController: ATLConversationViewControllerDelegate {

  func conversationViewController(viewController: ATLConversationViewController!, didSendMessage message: LYRMessage!) {
    println("Message Sent!")
  }
  
  func conversationViewController(viewController: ATLConversationViewController!, didFailSendingMessage message: LYRMessage!, error: NSError!) {
    println("Message failed to sent with error: \(error)")
  }
  
  func conversationViewController(viewController: ATLConversationViewController!, didSelectMessage message: LYRMessage!) {
    println("Message selected!")
  }
  
}

extension ConversationViewController: ATLParticipantTableViewControllerDelegate {
  
  func participantTableViewController(participantTableViewController: ATLParticipantTableViewController!, didSearchWithString searchText: String!, completion: ((Set<NSObject>!) -> Void)!) {
    println("Searching for text: \(searchText)")
  }
  
  func participantTableViewController(participantTableViewController: ATLParticipantTableViewController!, didSelectParticipant participant: ATLParticipant!) {
    self.addressBarController.selectParticipant(participant)
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
}

extension ConversationViewController: ATLConversationViewControllerDataSource {
  
  func conversationViewController(conversationViewController: ATLConversationViewController!, participantForIdentifier participantIdentifier: String!) -> ATLParticipant! {
    if (participantIdentifier != nil) {
      return DataStore.sharedInstance.userForIdentifier(participantIdentifier)
    }
    return nil
  }
  
  func conversationViewController(conversationViewController: ATLConversationViewController!, attributedStringForDisplayOfDate date: NSDate!) -> NSAttributedString! {
    return NSAttributedString(string:self.dateFormatter.stringFromDate(date), attributes:
      [NSForegroundColorAttributeName: UIColor.grayColor(),
        NSFontAttributeName: UIFont.systemFontOfSize(14)])
  }
  
  func conversationViewController(conversationViewController: ATLConversationViewController!, attributedStringForDisplayOfRecipientStatus recipientStatus: [NSObject : AnyObject]!) -> NSAttributedString! {
    if recipientStatus.count == 0 {
      return nil
    }
    let checkmark:String = "✔︎"
    let textColor:UIColor = UIColor.lightGrayColor()
    
    var mergedStatuses:NSMutableAttributedString = NSMutableAttributedString(string: checkmark, attributes: [NSForegroundColorAttributeName: textColor])
    return mergedStatuses
  }
  
}
