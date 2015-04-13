//
//  ConversationsViewController.swift
//  conduit
//
//  Created by Sherman Leung on 3/7/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ConversationsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, LYRQueryControllerDelegate {
  
  var layerClient: LYRClient!
  var queryController: LYRQueryController!
  var conversations: [LYRConversation] = []
  var selectedIndex: NSIndexPath!
  
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuButton.addTarget(self.revealViewController(), action:"revealToggle:", forControlEvents:UIControlEvents.TouchUpInside)
    self.tableView.rowHeight = 70
    
    self.setupLayerNotificationObservers()
    self.fetchLayerConversations()
  }
  
  func setupLayerNotificationObservers() {
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
  
  func fetchLayerConversations() {
    // Fetch all conversations related to the user
    var query: LYRQuery = LayerHelpers.createQueryWithClass(LYRConversation.self)
    var predicate: LYRPredicate = LayerHelpers.createPredicateWithProperty("participants", _operator: LYRPredicateOperator.IsEqualTo, value: [LQSCurrentUserID])
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
    
    let cell = tableView.dequeueReusableCellWithIdentifier("ConversationsListItem", forIndexPath: indexPath) as! UITableViewCell

    return cell
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
    var conversation: LYRConversation = self.queryController.objectAtIndexPath(indexPath) as! LYRConversation
    var convCell: ConversationsTableViewCell = cell as! ConversationsTableViewCell
    
    convCell.licensePlateLabel.text = conversation.description
    convCell.dateLabel.text = LayerHelpers.LQSDateFormatter().stringFromDate(conversation.createdAt)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Fake
    self.selectedIndex = indexPath
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    performSegueWithIdentifier("conversation_segue", sender: self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "conversation_segue" {
      var next = segue.destinationViewController as! MessagesViewController
      next.conversation = self.queryController.objectAtIndexPath(self.selectedIndex) as! LYRConversation
    }
  }
  
  
  // MARK - Query Controller Delegate Methods

  func queryControllerWillChangeContent(queryController: LYRQueryController!) {
    self.tableView.beginUpdates()
  }
  
  func queryController(controller: LYRQueryController!, didChangeObject object: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: LYRQueryControllerChangeType, newIndexPath: NSIndexPath!) {
    
    switch(type) {
      
      case LYRQueryControllerChangeType.Insert:
        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        break
        
      case LYRQueryControllerChangeType.Update:
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        break

      case LYRQueryControllerChangeType.Move:
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        break

      case LYRQueryControllerChangeType.Delete:
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        break
    }
  }
  
  func queryControllerDidChangeContent(queryController: LYRQueryController!) {
    self.tableView.endUpdates()
  }
  
  
  // MARK - Layer Sync Notification Handler
  
  func didReceiveLayerClientWillBeginSynchronizationNotification(notification: NSNotification) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
  }
  
  func didReceiveLayerClientDidFinishSynchronizationNotification(notification: NSNotification) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
  }
  
  // MARK - Layer Object Change Notification Handler
  
  func didReceiveLayerObjectsDidChangeNotification(notification: NSNotification) {
    if (self.conversations.count == 0) {
      self.fetchLayerConversations()
      self.tableView.reloadData()
    }
  }

}

class ConversationsTableViewCell : UITableViewCell {
  @IBOutlet weak var licensePlateLabel: UILabel!
  @IBOutlet weak var latestMessageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
}
