//
//  ProfileViewController.swift
//  TenLines
//
//  Created by Nyasha on 12/4/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

    private var friends: Array<Artist>?
    private var sketches: Array<Sketch>?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var displaySwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up refresh callback.
        self.refreshControl?.addTarget(self, action: "refreshFriends:", forControlEvents: UIControlEvents.ValueChanged)

        // Load data right away.
        self.refreshFriends(nil)
        
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 50
        iconImageView.layer.borderWidth = 4
        iconImageView.layer.borderColor = UIColor(red: 0.6, green: 0.93, blue: 0.85, alpha: 1.0).CGColor
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func switchSelected(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    func refreshFriends(sender: AnyObject?) {
        self.tableView.reloadData()
        
        // Temporary load feed data from a file. Eventually we want to get this
        // data by invoking a web service instead.
        let path = NSBundle.mainBundle().pathForResource("friends", ofType: "json")
        let data = JSON(data: NSData(contentsOfFile: path!)!)
        friends = Artist.fromJSON(data)
        
        let path2 = NSBundle.mainBundle().pathForResource("feed", ofType: "json")
        let data2 = JSON(data: NSData(contentsOfFile: path2!)!)
        sketches = Sketch.fromJSON(data2)
        
        // Hide the loading indicator since we're done loading.
        self.refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func friendCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
        
        // Configure the cell...
        let iconImageView: UIImageView = cell.viewWithTag(20) as! UIImageView
        cell.backgroundColor = UIColor.clearColor()
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 50
        iconImageView.layer.borderWidth = 4
        iconImageView.layer.borderColor = UIColor(red: 0.6, green: 0.93, blue: 0.85, alpha: 1.0).CGColor
        
        // Get artist.
        let artist = friends![indexPath.row]
        
        // Name label.
        let nameLabel: UILabel = cell.viewWithTag(10) as! UILabel
        nameLabel.text = artist.firstname
        
        // Profile picture.
        if (artist.icon != nil) {
            iconImageView.image = artist.icon
        }
        else {
            { artist.loadIcon() } ~> { iconImageView.image = artist.icon }
        }
        
        return cell
    }
    
    func sketchCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sketchCell", forIndexPath: indexPath)
        let sketch = sketches![indexPath.row]
        
        // Configure cell. Some custom visual things, like a subtle drop shadow.
        cell.backgroundColor = UIColor.clearColor()
        let imageView: UIImageView = cell.viewWithTag(10) as! UIImageView
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).CGColor
        imageView.layer.borderWidth = 1
        
        // Load image.
        if (sketch.image != nil) {
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (displaySwitch.selectedSegmentIndex == 0) {
            return (friends == nil) ? 0 : friends!.count
        }
        else {
            return (sketches == nil) ? 0 : sketches!.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (displaySwitch.selectedSegmentIndex == 0) {
            return 119
        }
        else {
            return 325
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        if (displaySwitch.selectedSegmentIndex == 0) {
            return friendCellForIndexPath(indexPath)
        }
        else {
            return sketchCellForIndexPath(indexPath)
        }
    }
}
