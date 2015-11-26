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
        
        // Setup refresh callback.
        self.refreshControl?.addTarget(self, action: "refreshFeed:", forControlEvents: UIControlEvents.ValueChanged)

        // Setup background color.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Programmatically create rounded corners for new sketch button.
        newSketchButton.clipsToBounds = true;
        newSketchButton.layer.cornerRadius = 65;
        
        // Center new sketch button.
        newSketchButton.center = CGPoint.init(x: self.view.frame.width / 2, y: newSketchButton.center.y);

        // Load feed immediately.
        let path = NSBundle.mainBundle().pathForResource("feed", ofType: "json")
        let data = JSON(data: NSData(contentsOfFile: path!)!)
        feedItems = Sketch.fromJSON(data)
        
        self.tableView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshFeed(sender: AnyObject?) {
        // Temporary load feed data from a file. Eventually we want to get this
        // data by invoking a web service instead.
        let path = NSBundle.mainBundle().pathForResource("feed2", ofType: "json")
        let data = JSON(data: NSData(contentsOfFile: path!)!)
        feedItems = Sketch.fromJSON(data)
        
        // Reload data.
        self.tableView.reloadData()
        
        // Hide the loading indicator since we're done loading.
        self.refreshControl?.endRefreshing()
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
    
    func upvote(sender: UIButton) {
        var count = 0
        if (sender.titleForState(UIControlState.Normal) != nil) {
            count = Int(sender.titleForState(UIControlState.Normal)!)!
        }
        ++count
        sender.setTitle(String(count), forState: UIControlState.Normal)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let sketch = feedItems![indexPath.row]
        
        // Configure cell. Some custom visual things, like a subtle drop shadow.
        cell.backgroundColor = UIColor.clearColor()
        let imageView: UIImageView = cell.viewWithTag(10) as! UIImageView
        imageView.layer.masksToBounds = false
        imageView.layer.shadowColor = UIColor(white: 0.7, alpha: 1.0).CGColor
        imageView.layer.shadowOffset = CGSizeMake(0, 0)
        imageView.layer.shadowOpacity = 0.3 

        // Load image.
        if (feedItems![indexPath.row].image != nil) {
            imageView.image = sketch.image
        }
        else {
            // Fetch the image on a background thread, then show it.
            // The first block here denotes something done on a background thread.
            // The second block denotes something to do after the first block completes.
            // See Threading.swift for details on how this works.
            { sketch.loadImage() } ~> { imageView.image = sketch.image }
        }
        
        // Upvote button.
        let upvoteButton: UIButton = cell.viewWithTag(20) as! UIButton
        let numUpvotes = sketch.upvotes
        upvoteButton.addTarget(self, action:"upvote:", forControlEvents: UIControlEvents.TouchUpInside);
        upvoteButton.setTitle(String(numUpvotes), forState: UIControlState.Normal)
        
        // Comments button.
        let commentButton: UIButton = cell.viewWithTag(30) as! UIButton
        let numComments = sketch.comments.count
        commentButton.setTitle(String(numComments), forState: UIControlState.Normal);
        
        // Line count label.
        let lineLabel: UILabel = cell.viewWithTag(40) as! UILabel
        lineLabel.text = "\(sketch.artists.count) artists, \(sketch.lines) lines"
        
        // Sketch title label.
        let titleLabel: UILabel = cell.viewWithTag(50) as! UILabel
        titleLabel.text = sketch.title
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showSketch") {
            let path = self.tableView.indexPathForSelectedRow
            let commentController = segue.destinationViewController as! CommentController
            commentController.sketch = feedItems![path!.row]
        }
    }
}
