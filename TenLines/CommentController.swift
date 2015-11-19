//
//  CommentController.swift
//  TenLines
//
//  Created by Sarah Wymer on 11/19/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class CommentController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var commentField: UITextView!
    
    @IBAction func sendComment(sender: AnyObject) {
        commentField.text = commentField.text! + "\n" + userTextField.text!
        userTextField.text = ""
    }
    
}



