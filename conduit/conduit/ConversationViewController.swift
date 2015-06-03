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
  var isEmptyConversation : Bool = false
  var messageText: String?

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
    self.messageInputToolbar.textInputView.font = UIFont(name: StyleHelpers.FONT_NAME, size: StyleHelpers.FONT_SIZE)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if self.isEmptyConversation {
      self.messageInputToolbar.textInputView.becomeFirstResponder()
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    var title: String = ""
    if conversation != nil {
      if let license_plate = conversation.metadata["license_plate"] as? String {
        title = license_plate
      }
    }
    
    self.navigationItem.title = title
    AnalyticsHelper.trackScreen("Conversation")
    StyleHelpers.setButtonFont(self.messageInputToolbar.rightAccessoryButton)
  }

  func sendInitMessage() {
    // If no conversations exist, create a new conversation object with a single participant
    if (self.conversation == nil) {
      var error:NSError? = nil
      self.conversation = self.layerClient.newConversationWithParticipants(
        NSSet(array: self.participantIdentifiers!) as Set<NSObject>, options: nil, error: &error
      )
      if (self.conversation == nil) {
        NSLog("New Conversation creation failed: \(error)")
        return
      }
      
      self.conversation.setValue(self.licensePlate, forMetadataAtKeyPath: "license_plate")
      NSLog("Creating conversation for license_plate: \(self.licensePlate) and requester_name: \(User.getUserFromDefaults()!.firstName)")
      self.conversation.setValue(User.getUserFromDefaults()!.firstName, forMetadataAtKeyPath: "requester_name")
    }
    
    if self.messageText == "" {
      NSLog("Empty conversation created")
      self.isEmptyConversation = true
      return
    }
    
    var messagePart: LYRMessagePart = LYRMessagePart(text: self.messageText)
    var pushMessage: String = "New Message: \"\(self.messageText!)\""
    var message: LYRMessage = self.layerClient.newMessageWithParts([messagePart], options: [LYRMessageOptionsPushNotificationAlertKey: pushMessage], error: nil)
    
    // Send message
    var error:NSError? = nil
    
    var success:Bool = self.conversation.sendMessage(message, error:&error)
    if (success) {
      NSLog("Message queued to be sent: \(self.messageText)");
      resetViewControllers()
    } else {
      NSLog("Message send failed: \(error)");
    }
    
  }
  
  func resetViewControllers() {
    performSegueWithIdentifier("send_to_conversation", sender: self)
  }
 
  func configureUIColors () {
    ATLIncomingMessageCollectionViewCell.appearance().bubbleViewCornerRadius = 10

    ATLIncomingMessageCollectionViewCell.appearance().bubbleViewColor = ATLLightGrayColor()
    ATLIncomingMessageCollectionViewCell.appearance().messageTextColor = TextColor.getTextColor(.Dark)
    ATLIncomingMessageCollectionViewCell.appearance().messageLinkTextColor = StyleColor.getColor(.Secondary, brightness:.Dark)
    ATLIncomingMessageCollectionViewCell.appearance().messageTextFont = UIFont(name: StyleHelpers.FONT_NAME, size: StyleHelpers.FONT_SIZE)
    
    ATLOutgoingMessageCollectionViewCell.appearance().bubbleViewCornerRadius = 10
    ATLOutgoingMessageCollectionViewCell.appearance().bubbleViewColor = StyleColor.getColor(.Primary, brightness: .Light)
    ATLOutgoingMessageCollectionViewCell.appearance().messageTextColor = UIColor.whiteColor()
    ATLOutgoingMessageCollectionViewCell.appearance().messageLinkTextColor = UIColor.whiteColor()
    ATLOutgoingMessageCollectionViewCell.appearance().messageTextFont = UIFont(name: StyleHelpers.FONT_NAME, size: StyleHelpers.FONT_SIZE)
    
    ATLMessageInputToolbar.appearance().tintColor = TextColor.getTextColor(.Dark)
  }
  
  func promptSaveToPresets() {
    
    if !self.isEmptyConversation {
      return
    }
    
    var messagePart:LYRMessagePart = self.conversation.lastMessage.parts[0] as! LYRMessagePart
    let messageText = NSString(data: messagePart.data, encoding: NSUTF8StringEncoding) as! String

    var alert = UIAlertController(title: "Save as a preset message?", message: messageText, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
      DataStore.sharedInstance.addPresetMessage(messageText)
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
    
    dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
      self.presentViewController(alert, animated: true, completion: nil)
    }
    
    self.isEmptyConversation = false
  }
 
}

extension ConversationViewController: ATLConversationViewControllerDelegate {

  func conversationViewController(viewController: ATLConversationViewController!, didSendMessage message: LYRMessage!) {
    println("Message Sent! \(message)")
    
    if self.isEmptyConversation {
      self.resetViewControllers()
    }
    
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

    var currentUser: User = User.getUserFromDefaults()!
    return currentUser
  }
  
  func conversationViewController(conversationViewController: ATLConversationViewController!, attributedStringForDisplayOfDate date: NSDate!) -> NSAttributedString! {
    return NSAttributedString(string:self.dateFormatter.stringFromDate(date), attributes:
      [NSForegroundColorAttributeName: UIColor.grayColor(),
        NSFontAttributeName: UIFont(name: StyleHelpers.FONT_NAME, size:StyleHelpers.FONT_SIZE)!])
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
