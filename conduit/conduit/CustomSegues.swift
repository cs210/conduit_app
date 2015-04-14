//
//  CustomSegue.swift
//  conduit
//
//  Created by Nathan Eidelson on 4/14/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import Foundation

class SendToConversationSegue: UIStoryboardSegue {
  
  override func perform() {
    var sourceViewController: NewMessageViewController = self.sourceViewController as! NewMessageViewController
    var navigationController: UINavigationController = sourceViewController.navigationController!
    
    // Go back to the basics
    navigationController.popToRootViewControllerAnimated(false)
    
    // Switch to conversations view from root side menu
    var revealController: SWRevealViewController = navigationController.revealViewController()
    revealController.rearViewController.performSegueWithIdentifier("conversations_segue", sender: self)
    
    var conversationsNavigationController: NavigationController = revealController.frontViewController as! NavigationController
    var conversationsController: ConversationsViewController = conversationsNavigationController.visibleViewController as! ConversationsViewController
    // Create messages view
    var messagesViewController: MessagesViewController = conversationsController.storyboard?.instantiateViewControllerWithIdentifier("messagesViewController") as! MessagesViewController
    
    // Push messages view
    conversationsNavigationController.pushViewController(messagesViewController, animated: false)
    
    messagesViewController.sendMessage(sourceViewController.selectedMessage)

  }
  
}