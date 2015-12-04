//
//  InvitesViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/30/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class InvitesViewController: UITableViewController {
    
    /* List of invites you've received. */
    private var invites: Array<Invite>?
    
    /* List of public drawings to join */
    private var anonymous: Array<Invite>?
    
    /* Switch for displaying invites vs public drawings. */
    @IBOutlet weak var inviteSwitch: UISegmentedControl!
    
    @IBAction func onSwitchSelected(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup refresh callback.
        self.refreshControl?.addTarget(self, action: "refreshInvites:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Setup background color.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        // Load friends right away.
        self.refreshInvites(nil)
    }
    
    func refreshInvites(sender: AnyObject?) {
        // Temporary load feed data from a file. Eventually we want to get this
        // data by invoking a web service instead.
        let path = NSBundle.mainBundle().pathForResource("invites", ofType: "json")
        let data = JSON(data: NSData(contentsOfFile: path!)!)
        invites = Invite.fromJSON(data)
        
        let path2 = NSBundle.mainBundle().pathForResource("invites2", ofType: "json")
        let data2 = JSON(data: NSData(contentsOfFile: path2!)!)
        anonymous = Invite.fromJSON(data2)
        
        // Reload data.
        self.tableView.reloadData()
        
        // Hide the loading indicator since we're done loading.
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (inviteSwitch.selectedSegmentIndex == 0) {
            return invites!.count
        }
        else {
            return anonymous!.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (inviteSwitch.selectedSegmentIndex == 0) {
            return "Sketch with friends!"
        }
        else {
            return "Sketch with the public!"
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = UILabel()
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Avenir Book", size: 17)
        label.textColor = UIColor.lightGrayColor()
        label.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        return label
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // Configure the cell...
        let iconImageView: UIImageView = cell.viewWithTag(100) as! UIImageView
        cell.backgroundColor = UIColor.clearColor()
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 50
        iconImageView.layer.borderWidth = 4
        iconImageView.layer.borderColor = UIColor(red: 0.6, green: 0.93, blue: 0.85, alpha: 1.0).CGColor
        
        // Get invite.
        var invite: Invite = invites![indexPath.row]
        if (inviteSwitch.selectedSegmentIndex == 0) {
            invite = invites![indexPath.row]
        }
        else {
            invite = anonymous![indexPath.row]
        }
        
        // Name label.
        let nameLabel: UILabel = cell.viewWithTag(11) as! UILabel
        if (inviteSwitch.selectedSegmentIndex == 0) {
            nameLabel.text = invite.firstname + " invited you!"
        }
        else {
            nameLabel.text = "Created by " + invite.firstname
        }
        
        // Preview picture.
        if (invite.preview != nil) {
            iconImageView.image = invite.preview
        }
        else {
            { invite.loadPreview() } ~> { iconImageView.image = invite.preview }
        }
        
        // Set acessory view based on selection state.
        let selectedRows = tableView.indexPathsForSelectedRows
        if (selectedRows != nil && selectedRows!.contains(indexPath)) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
}
