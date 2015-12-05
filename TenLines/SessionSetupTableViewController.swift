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
    private var titleCell: UITableViewCell?
    private var switchCell: UITableViewCell?
    
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
    
    func refreshFriends(sender: AnyObject?) {
        ({ self.friends = AccountManager.sharedManager.getUsers() }
        ~>
        {
            // Hide the loading indicator since we're done loading.
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true);
    }
    
    // MARK: - Helper methods for configuring table view cells
    
    func textCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.selectedBackgroundView = nil
        titleCell = cell
        return cell
    }
    
    func switchCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath)
        switchCell = cell
        return cell
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
        nameLabel.text = (artist.firstname == nil) ? artist.username : artist.firstname
        
        // Profile picture.
        iconImageView.image = UIImage(named: "profile_placeholder.png")
        if (artist.icon != nil) {
            iconImageView.image = artist.icon
        }
        else {
            { artist.loadIcon() } ~> { if (artist.icon != nil) { iconImageView.image = artist.icon } }
        }
        
        // Set acessory view based on selection state.
        removeCheckMarkFromCell(cell, animated: false)
        let selectedRows = tableView.indexPathsForSelectedRows
        if (selectedRows != nil && selectedRows!.contains(indexPath)) {
            addCheckMarkToCell(cell, animated: false)
        }
        
        return cell
    }
    
    func addCheckMarkToCell(cell: UITableViewCell, animated: Bool) {
        let iconImageView: UIImageView = cell.viewWithTag(20) as! UIImageView
        
        // Add overlay.
        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        overlayView.center = CGPoint(x: iconImageView.frame.size.width / 2, y: iconImageView.frame.size.height / 2)
        overlayView.backgroundColor = UIColor(red: 0.15, green: 0.23, blue: 0.21, alpha: 0.5)
        overlayView.layer.cornerRadius = 50
        overlayView.tag = 100001
        iconImageView.addSubview(overlayView)
        
        // Add check mark.
        let checkmark = UIImageView(image: UIImage(named: "checkmark.png"))
        checkmark.frame = overlayView.bounds
        checkmark.contentMode = UIViewContentMode.Center
        overlayView.addSubview(checkmark)
        
        // Create blank accessory view to force indent.
        let accessoryView = UIView(frame: CGRectZero)
        accessoryView.backgroundColor = UIColor.clearColor()
        cell.accessoryView = accessoryView
        
        // Animate it.
        let duration = (animated) ? 0.3 : 0.0
        UIView.animateWithDuration(duration) {
            overlayView.center = CGPoint(x: iconImageView.frame.size.width / 2, y: iconImageView.frame.size.height / 2)
            overlayView.frame = iconImageView.bounds
            checkmark.frame = overlayView.bounds
            cell.accessoryView!.frame = CGRect(x: 0, y: 0, width: 30, height: 10)
        }
    }
    
    func removeCheckMarkFromCell(cell: UITableViewCell, animated: Bool) {
        let iconImageView: UIImageView = cell.viewWithTag(20) as! UIImageView
        let _ = iconImageView.subviews.map({subview in subview.removeFromSuperview()})
        cell.accessoryView = nil
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Add title"
        }
        else {
            return "Invite some friends"
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont(name: "AmaticSC-Bold", size: 30)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        return label
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 75
            }
            else {
                return 50
            }
        }
        return 120
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        }
        return friends != nil ? friends!.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return textCellForIndexPath(indexPath)
            }
            else {
                return switchCellForIndexPath(indexPath)
            }
        }
        else {
            return friendCellForIndexPath(indexPath)
        }
    }

    // MARK: - Navigation

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            addCheckMarkToCell(cell!, animated: true)
            
            // Show start button once at least 1 friend has been invited.
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            removeCheckMarkFromCell(cell!, animated: true)
            
            // Hide start button if no friends are selected.
            if (tableView.indexPathsForSelectedRows == nil) {
                self.navigationController?.setToolbarHidden(true, animated: true);
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "newSketch") {
            // Fetch sketch title.
            let titleLabel = titleCell?.viewWithTag(10) as! UITextField
            let publicSwitch = switchCell?.viewWithTag(20) as! UISwitch
            
            // Load sketch.
            var sketch: Sketch?
            ({
                // Get title.
                var title: String?
                if (titleLabel.text == nil || titleLabel.text == "") {
                    title = "Untitled"
                }
                else {
                    title = titleLabel.text!
                }
                
                sketch = AccountManager.sharedManager.createSketchWithTitle(title!, ispublic: publicSwitch.on)
            }
            ~>
            {
                let whiteboardController = segue.destinationViewController as! WhiteboardViewController
                whiteboardController.sketch = sketch!
                
                // Invite selected friends.
                let paths = self.tableView.indexPathsForSelectedRows!
                for path in paths {
                    let friend = self.friends![path.row]
                    ({ AccountManager.sharedManager.inviteUser(friend.id!, toSketch: sketch!) } ~> {})
                }
            })
        }
    }

}
