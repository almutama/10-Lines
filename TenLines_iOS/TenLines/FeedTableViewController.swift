//
//  FeedTableViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit
import QuartzCore

class FeedTableViewController: UITableViewController {
    
    @IBOutlet weak var newSketchButton: UIButton!
    
    // List of sketches currently displayed in feed.
    private var feedItems: Array<Sketch>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table view cell class.
        let cellNib: UINib? = UINib(nibName: "SketchTableViewCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "sketchCell")
        
        // Setup refresh callback.
        self.refreshControl?.addTarget(self, action: #selector(FeedTableViewController.refreshFeed(_:)), forControlEvents: UIControlEvents.ValueChanged)

        // Setup background color.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Programmatically create rounded corners for new sketch button.
        newSketchButton.clipsToBounds = true;
        newSketchButton.layer.cornerRadius = 65;
        
        // Center new sketch button.
        newSketchButton.center = CGPoint.init(x: self.view.frame.width / 2, y: newSketchButton.center.y);

        // Load feed immediately.
        self.refreshFeed(nil)
    }
    
    func refreshFeed(sender: AnyObject?) {
        ({ self.feedItems = AccountManager.sharedManager.getAllSketches() }
        ~>
        {
            // Hide the loading indicator since we're done loading.
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func upvote(sender: UIButton) {
        var count = 0
        if (sender.titleForState(UIControlState.Normal) != nil) {
            count = Int(sender.titleForState(UIControlState.Normal)!)!
        }
        count += 1
        sender.setTitle(String(count), forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true);
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 325
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems != nil ? feedItems!.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sketchCell", forIndexPath: indexPath)
        let sketchCell: SketchTableViewCell? = cell as? SketchTableViewCell
        let sketch: Sketch? = feedItems?[indexPath.row]
        sketchCell?.configureForSketch(sketch)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showComments", sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showComments") {
            let path = self.tableView.indexPathForSelectedRow
            let commentController = segue.destinationViewController as! CommentController
            commentController.sketch = feedItems![path!.row]
        }
    }
}
