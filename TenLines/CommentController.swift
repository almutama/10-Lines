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
    
    /* References to UI elements. */
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    /* The sketch shown by this comment controller. This is set by the
     * previously visible controller upone a segue. */
    var sketch: Sketch!
    
    /* Upvotes the currently displayed sketch. */
    @IBAction func upvote(sender: AnyObject) {
        var count = 0
        if (sender.titleForState(UIControlState.Normal) != nil) {
            count = Int(sender.titleForState(UIControlState.Normal)!)!
        }
        ++count
        sender.setTitle(String(count), forState: UIControlState.Normal)
    }
    
    /* Adds a comment to the currently displayed sketch. */
    @IBAction func sendComment(sender: AnyObject) {
        if userTextField.text != "" {
            let comment = "User Name" + "\n" + userTextField.text! + "\n\n"
            commentField.text = comment + commentField.text!
            userTextField.text = ""
            
            sketch.addComment(comment)
            commentButton.setTitle(String(sketch.comments.count), forState: UIControlState.Normal);
        }
    }
    
    /* Callback function for setup after the view loads. */
    override func viewDidLoad() {
        // Setup view.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.shadowColor = UIColor(white: 0.7, alpha: 1.0).CGColor
        self.imageView.layer.shadowOffset = CGSizeMake(0, 0)
        self.imageView.layer.shadowOpacity = 0.5
        
        // Load image.
        if (sketch.image != nil) {
            self.imageView.image = sketch.image
        }
        else {
            // Load image asynchronously if it's not available.
            // The first block here denotes something done on a background thread.
            // The second block denotes something to do after the first block completes.
            // See Threading.swift for details on how this works.
            { self.sketch.loadImage() } ~> { self.imageView.image = self.sketch.image }
        }
        
        // Upvote button.
        upvoteButton.setTitle(String(sketch.upvotes), forState: UIControlState.Normal)
        
        // Line count label.
        captionLabel.text = "\(sketch.artists.count) artists, \(sketch.lines) lines"
        
        // Comments button.
        commentButton.setTitle(String(sketch.comments.count), forState: UIControlState.Normal);
        
        // Sketch title label.
        titleLabel.text = sketch.title
    }
}



