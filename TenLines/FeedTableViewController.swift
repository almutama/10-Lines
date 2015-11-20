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
    
    private var feedItems: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup refresh callback.
        self.refreshControl?.addTarget(self, action: "refreshFeed:", forControlEvents: UIControlEvents.ValueChanged)

        // Setup background color.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        // Load feed immediately.
        let path = NSBundle.mainBundle().pathForResource("feed", ofType: "json")
        feedItems = JSON(data: NSData(contentsOfFile: path!)!)
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
        feedItems = JSON(data: NSData(contentsOfFile: path!)!)
        
        // Reload data.
        self.tableView.reloadData()
        
        // Hide the loading indicator since we're done loading.
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350
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
        
        // Configure cell.
        cell.backgroundColor = UIColor.clearColor()
        let imageView: UIImageView = cell.viewWithTag(10) as! UIImageView
        imageView.layer.masksToBounds = false
        imageView.layer.shadowColor = UIColor(white: 0.7, alpha: 1.0).CGColor
        imageView.layer.shadowOffset = CGSizeMake(0, 0)
        imageView.layer.shadowOpacity = 0.3

        // Load image.
        let imageURL: String = feedItems![indexPath.row]["url"].string!
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: imageURL)!)
        let mainQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object.
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue(), {
                    imageView.image = image
                })
            }
            else {
                print("Error: \(error!.localizedDescription)")
            }
        })
        
        // Upvote button.
        let upvoteButton: UIButton = cell.viewWithTag(20) as! UIButton
        let numUpvotes = feedItems![indexPath.row]["upvotes"].int
        upvoteButton.addTarget(self, action:"upvote:", forControlEvents: UIControlEvents.TouchUpInside);
        upvoteButton.setTitle(String(numUpvotes!), forState: UIControlState.Normal)
        
        // Comments button.
        let commentButton: UIButton = cell.viewWithTag(30) as! UIButton
        let numComments = feedItems![indexPath.row]["comments"].int
        commentButton.setTitle(String(numComments!), forState: UIControlState.Normal);
        
        // Line count label.
        let lineLabel: UILabel = cell.viewWithTag(40) as! UILabel
        lineLabel.text = "\(feedItems![indexPath.row]["artists"].count) artists, \(feedItems![indexPath.row]["lines"].int!) lines"
        
        // Sketch title label.
        let titleLabel: UILabel = cell.viewWithTag(50) as! UILabel
        titleLabel.text = feedItems![indexPath.row]["title"].string!
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showSketch") {
            let path = self.tableView.indexPathForSelectedRow
            let imageURL: String = feedItems![path!.row]["url"].string!
            let commentController = segue.destinationViewController as! CommentController
            commentController.pictureURL = imageURL
        }
    }
}
