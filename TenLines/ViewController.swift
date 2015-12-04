//
//  ViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Center items horizontally.
        logoImageView.center = CGPoint.init(x: self.view.frame.width / 2, y: logoImageView.center.y);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerNewUser(sender: AnyObject) {
        if (self.usernameTextField.text != nil && self.passwordTextField.text != nil &&
            self.usernameTextField.text != "") {
            let username = self.usernameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let password = self.passwordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var success: Bool = false
            ({ success = AccountManager.sharedManager.register(username, password: password) }
            ~>
            {
                if (success) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainNavigationController = storyboard.instantiateViewControllerWithIdentifier("mainNavigationController")
                    self.presentViewController(mainNavigationController, animated: true, completion: nil)
                }
            })
        }
    }
    
    // Mark: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (self.usernameTextField.text != nil && self.passwordTextField.text != nil) {
            let username = self.usernameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let password = self.passwordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var success: Bool = false
            ({ success = AccountManager.sharedManager.login(username, password: password) }
            ~>
            {
                if (success) {
                    textField.resignFirstResponder()
   
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainNavigationController = storyboard.instantiateViewControllerWithIdentifier("mainNavigationController")
                    self.presentViewController(mainNavigationController, animated: true, completion: nil)
                }
            })
            return true
        }
        return false
    }

}

