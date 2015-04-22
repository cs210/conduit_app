//
//  ConfirmPasswordViewController.swift
//  conduit
//
//  Created by Sherman Leung on 4/21/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

import UIKit

protocol ConfirmPasswordDelegate {
  func nextSegueAfterConfirm(segueId: String)
}
class ConfirmPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var passwordField: UITextField!
    var nextSegueID: String!
    var delegate: ConfirmPasswordDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
     
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  @IBAction func confirmPassword(sender: AnyObject) {
    delegate?.nextSegueAfterConfirm(nextSegueID)
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    passwordField.resignFirstResponder()
    confirmPassword(passwordField)
    return true
  }

}
