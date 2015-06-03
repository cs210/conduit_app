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
    var sourceViewController: ConversationViewController = self.sourceViewController as! ConversationViewController
    var navigationController: UINavigationController = sourceViewController.navigationController!
    
    // Go back to the basics
    navigationController.popToRootViewControllerAnimated(false)
    
    // Switch to conversations view from root side menu
    var revealController: SWRevealViewController = navigationController.revealViewController()
    var newNavController : UINavigationController = revealController.rearViewController as! UINavigationController
    
    var rootViewController = newNavController.topViewController
    
    rootViewController.performSegueWithIdentifier("conversations_segue", sender: self)
    
    var conversationListNavigationController: UINavigationController = revealController.frontViewController as! UINavigationController
    var conversationListController: ConversationListViewController = conversationListNavigationController.visibleViewController as! ConversationListViewController

    conversationListNavigationController.pushViewController(sourceViewController, animated: false)
    
    sourceViewController.promptSaveToPresets()
  }
  
}

class CreateConversationSegue: UIStoryboardSegue {
  
  override func perform() {
    var sourceViewController: NewMessageViewController = self.sourceViewController as! NewMessageViewController
    var destinationViewController: ConversationViewController = self.destinationViewController as! ConversationViewController
  
    sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
    destinationViewController.sendInitMessage()
  }
  
}

