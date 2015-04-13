//
//  MessagesViewController.swift
//  conduit
//
//  Created by Nisha Masharani on 4/2/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit

class MessagesViewController : UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, LYRQueryControllerDelegate {
  
  var conversation: LYRConversation!
  var layerClient: LYRClient!
  var queryController: LYRQueryController!
  var messages : [LYRMessage] = []
  
  @IBOutlet weak var navBar: UINavigationItem!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var sendButton: UIButton!
  
  @IBOutlet weak var isTypingLabel: UILabel!
  
  @IBOutlet weak var inputTextView: UITextView!

  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.estimatedRowHeight = 44.0
    self.tableView.rowHeight = UITableViewAutomaticDimension
    
    self.setupLayerNotificationObservers()
    self.fetchLayerMessages()
  }
  
  func setupLayerNotificationObservers() {
    
    // Register for typing indicator notifications
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: Selector("didReceiveTypingIndicator"),
      name: LYRConversationDidReceiveTypingIndicatorNotification, object: self.conversation)
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: Selector("didReceiveLayerObjectsDidChangeNotification"),
      name: LYRClientObjectsDidChangeNotification, object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: Selector("didReceiveLayerClientWillBeginSynchronizationNotification"),
      name: LYRClientWillBeginSynchronizationNotification, object: self.layerClient)
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: Selector("didReceiveLayerClientDidFinishSynchronizationNotification"),
      name: LYRClientDidFinishSynchronizationNotification, object: self.layerClient)
  }
  
  func fetchLayerMessages() {
    // Fetch all conversations related to the user
    var query: LYRQuery = LayerHelpers.createQueryWithClass(LYRMessage.self)
    var predicate: LYRPredicate = LayerHelpers.createPredicateWithProperty("conversation", _operator: LYRPredicateOperator.IsEqualTo, value: self.conversation)
    query.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
    
    self.queryController = self.layerClient.queryControllerWithQuery(query)
    self.queryController.delegate = self
    
    var error: NSError? = NSError()
    
    var success: Bool = self.queryController.execute(&error)
    
    if (success) {
      NSLog("Query fetched \(self.queryController.numberOfObjectsInSection(0)) message objects");
    } else {
      NSLog("Query failed with error: \(error)");
    }
  }

  // MARK - Table View Data Source Methods
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count: UInt = self.queryController.numberOfObjectsInSection(UInt(section))
    var countAsInt: Int = Int(count)
    return countAsInt
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! UITableViewCell
    return cell
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
    var message: LYRMessage = self.queryController.objectAtIndexPath(indexPath) as! LYRMessage
    var messageCell: MessagesTableViewCell  = cell as! MessagesTableViewCell
    
    // Set Message Text
    var messagePart: LYRMessagePart = message.parts[0] as! LYRMessagePart
    
    messageCell.messageText.text = NSString(data: messagePart.data, encoding: NSUTF8StringEncoding) as? String
  }
  
  
  // MARK - Receiving Typing Indicator
  func didReceiveTypingIndicator(notification: NSNotification) {
   // add code
  }
  
  // MARK - IBActions
  
  @IBAction func sendButtonPressed(sender: AnyObject) {
    self.sendMessage(self.inputTextView.text)
  }
  
  func sendMessage(messageText: String) {
    // If no conversations exist, create a new conversation object with a single participant
    if (self.conversation == nil) {
      var error:NSError? = nil
      self.conversation = self.layerClient.newConversationWithParticipants(
        NSSet(array: [LQSParticipantUserID, LQSParticipant2UserID]) as Set<NSObject>, options: nil, error: &error)
      
      if (self.conversation == nil) {
         NSLog("New Conversation creation failed: \(error)")
      }
    }
    
    var messagePart: LYRMessagePart = LYRMessagePart(text: messageText)
    var pushMessage: String = "\(self.layerClient.authenticatedUserID) says \(messageText)"
    var message: LYRMessage = self.layerClient.newMessageWithParts([messagePart], options: [LYRMessageOptionsPushNotificationAlertKey: pushMessage], error: nil)
    
    // Send message
    var error:NSError? = nil
    
    var success:Bool = self.conversation.sendMessage(message, error:&error)
    if (success) {
      NSLog("Message queued to be sent: \(messageText)");
      self.inputTextView.text = "";
    } else {
      NSLog("Message send failed: \(error)");
    }

  }
  

}

class MessagesTableViewCell : UITableViewCell {
  @IBOutlet weak var messageText: UILabel!
}
