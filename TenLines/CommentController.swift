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
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    var pictureURL: String!
    
    @IBAction func sendComment(sender: AnyObject) {
        commentField.text = commentField.text! + "\n" + "User Name" + "\n" + userTextField.text! + "\n"
        userTextField.text = ""
    }
    
    override func viewDidLoad() {
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: pictureURL)!)
        let mainQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object.
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.pictureImageView.image = image
                })
            }
            else {
                print("Error: \(error!.localizedDescription)")
            }
        })
    }
}



