//
//  CommentController.swift
//  TenLines
//
//  Created by Sarah Wymer on 11/19/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class CommentController: UITableViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    
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
        // Disallow blank comments.
        if userTextField.text != "" {
            let comment = Comment()
            comment.username = "anonymous aardvark"
            comment.text = userTextField.text!
            
            // Clear text field.
            userTextField.text = ""
            
            // Add comment to data object.
            sketch.addComment(comment)
            
            // Update comment count.
            commentButton.setTitle(String(sketch.comments), forState: UIControlState.Normal);
            
            // Insert a new table row for the new comment.
            //let newPath = NSIndexPath(forRow: sketch.comments - 1, inSection: 0)
            //self.tableView.insertRowsAtIndexPaths([newPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    /* Callback function for setup after the view loads. */
    override func viewDidLoad() {
        // Setup view.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).CGColor
        self.imageView.image = UIImage(named: "sketch_placeholder.png")
        
        // Load image.
        if (sketch.image != nil) {
            self.imageView.image = sketch.image
        }
        else {
            // Load image asynchronously if it's not available.
            // The first block here denotes something done on a background thread.
            // The second block denotes something to do after the first block completes.
            // See Threading.swift for details on how this works.
            { self.sketch.loadImage() } ~> { if (self.sketch.image != nil) { self.imageView.image = self.sketch.image } }
        }
        
        // Upvote button.
        upvoteButton.setTitle(String(sketch.upvotes), forState: UIControlState.Normal)
        
        // Line count label.
        /*captionLabel.text = "\(sketch.artists.count) artists, \(sketch.lines) lines"
        
        // Comments button.
        commentButton.setTitle(String(sketch.comments.count), forState: UIControlState.Normal);
        */
        // Sketch title label.
        titleLabel.text = sketch.title
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true);
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sketch.comments!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        
        // Configure cell...
        /*
        cell.textLabel?.text = sketch.comments[indexPath.row].username
        cell.detailTextLabel?.text = sketch.comments[indexPath.row].text
        */
        
        return cell
    }
}



