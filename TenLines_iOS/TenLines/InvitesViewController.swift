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
    private var invites: Array<Sketch>?
    
    /* List of public drawings to join */
    private var anonymous: Array<Sketch>?
    
    /* Switch for displaying invites vs public drawings. */
    @IBOutlet weak var inviteSwitch: UISegmentedControl!
    
    @IBAction func onSwitchSelected(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table view cell class.
        let cellNib: UINib? = UINib(nibName: "HandleTableViewCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "handleCell")
        
        // Setup refresh callback.
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(InvitesViewController.refreshInvites(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Setup background color.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Load invites right away.
        self.refreshInvites(nil)
    }
    
    func refreshInvites(sender: AnyObject?) {
        ({
            self.invites = AccountManager.sharedManager.getInvites()
            self.anonymous = AccountManager.sharedManager.getPublicSketches()
        }
        ~>
        {
            // Hide the loading indicator since we're done loading.
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (inviteSwitch.selectedSegmentIndex == 0) {
            return (invites == nil) ? 0 : invites!.count
        }
        else {
            return (anonymous == nil) ? 0 : anonymous!.count
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
        let cell = tableView.dequeueReusableCellWithIdentifier("handleCell", forIndexPath: indexPath)
        let handleCell: HandleTableViewCell? = cell as? HandleTableViewCell
        
        // Get invite for this cell.
        var invite: Sketch = invites![indexPath.row]
        if (inviteSwitch.selectedSegmentIndex == 0) {
            invite = invites![indexPath.row]
        }
        else {
            invite = anonymous![indexPath.row]
        }
        handleCell?.configureForSketch(invite)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showSketch", sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showSketch") {
            let path = self.tableView.indexPathForSelectedRow
            
            // Load sketch.
            let invite = invites![path!.row]
            let whiteboardController = segue.destinationViewController as! WhiteboardViewController
            whiteboardController.sketch = invite
        }
    }
}
