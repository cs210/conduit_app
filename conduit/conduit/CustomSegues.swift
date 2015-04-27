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
    
//    println("Beginning send_to_conversation segue")
    var sourceViewController: NewMessageViewController = self.sourceViewController as! NewMessageViewController
//    println("Source View Controller: " + sourceViewController.restorationIdentifier!)
    
    var navigationController: UINavigationController = sourceViewController.navigationController!
//    println("Navigation Controller: " + navigationController.restorationIdentifier!)
    
    // Go back to the basics
    navigationController.popToRootViewControllerAnimated(false)
//    println("Navigation Controller After Pop: " + navigationController.restorationIdentifier!)
    
    
    // Switch to conversations view from root side menu
    var revealController: SWRevealViewController = navigationController.revealViewController()
//    println("Reveal Controller: " + revealController.restorationIdentifier!)
//    println("RevealController Rear View Controller: " + revealController.rearViewController.restorationIdentifier!)
    
    var newNavController : UINavigationController = revealController.rearViewController as! UINavigationController
    
    var rootViewController = newNavController.topViewController
    
//    println("RootViewController: " + rootViewController.restorationIdentifier!)
    
    rootViewController.performSegueWithIdentifier("conversations_segue", sender: self)
    
    var conversationListNavigationController: UINavigationController = revealController.frontViewController as! UINavigationController
    var conversationListController: ConversationListViewController = conversationListNavigationController.visibleViewController as! ConversationListViewController
    // Create messages view
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var conversationViewController: ConversationViewController = ConversationViewController(layerClient: appDelegate.layerClient)
    
    conversationViewController.conversation = nil
    conversationListNavigationController.pushViewController(conversationViewController, animated: false)

    conversationViewController.sendInitMessage(sourceViewController.selectedMessage)

  }
  
}

class CreateAcctToInviteSegue : UIStoryboardSegue {
  override func perform() {
    var sourceViewController: CreateAccountController = self.sourceViewController as! CreateAccountController
    var navigationController: UINavigationController = sourceViewController.navigationController!
    
    navigationController.dismissViewControllerAnimated(false, completion: nil)
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var revealController : SWRevealViewController = appDelegate.window!.rootViewController as! SWRevealViewController

    // Switch to invite friends view from root side menu
    revealController.rearViewController.performSegueWithIdentifier("invite_friends_segue", sender: self)
  }
}


