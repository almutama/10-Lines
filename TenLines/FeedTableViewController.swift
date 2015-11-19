//
//  FeedTableViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    private var feedItems: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup refresh callback.
        self.refreshControl?.addTarget(self, action: "refreshFeed:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Load feed immediately.
        self.refreshFeed(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshFeed(sender: AnyObject?) {
        self.tableView.reloadData()
        
        // Temporary load feed data from a file. Eventually we want to get this
        // data by invoking a web service instead.
        let path = NSBundle.mainBundle().pathForResource("feed", ofType: "json")
        feedItems = JSON(data: NSData(contentsOfFile: path!)!)
        
        // Hide the loading indicator since we're done loading.
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems != nil ? feedItems!.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        let imageView: UIImageView = cell.viewWithTag(10) as! UIImageView
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
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
