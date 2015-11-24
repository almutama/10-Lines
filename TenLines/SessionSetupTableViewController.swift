//
//  SessionSetupTableViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class SessionSetupTableViewController: UITableViewController {

    private var friends: Array<Artist>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up refresh callback.
        self.refreshControl?.addTarget(self, action: "refreshFriends:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Setup background color.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Load friends right away.
        self.refreshFriends(nil)
        
        self.tableView.allowsMultipleSelection = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshFriends(sender: AnyObject?) {
        self.tableView.reloadData()
        
        // Temporary load feed data from a file. Eventually we want to get this
        // data by invoking a web service instead.
        let path = NSBundle.mainBundle().pathForResource("friends", ofType: "json")
        let data = JSON(data: NSData(contentsOfFile: path!)!)
        friends = Artist.fromJSON(data)
        
        // Hide the loading indicator since we're done loading.
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends != nil ? friends!.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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

    // MARK: - Navigation

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
