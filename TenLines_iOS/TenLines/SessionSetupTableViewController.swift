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
        
        // Register table view cell class.
        let cellNib: UINib? = UINib(nibName: "HandleTableViewCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "handleCell")
        
        // Set up refresh callback.
        self.refreshControl?.addTarget(self, action: #selector(SessionSetupTableViewController.refreshFriends(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Setup background color.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        
        // Load friends right away.
        self.refreshFriends(nil)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("handleCell", forIndexPath: indexPath)
        let handleCell: HandleTableViewCell? = cell as? HandleTableViewCell
        let artist: Artist? = friends?[indexPath.row]
        handleCell?.configureForArtist(artist)
        
        // Set acessory view based on selection state.
        let selectedRows = tableView.indexPathsForSelectedRows
        if (selectedRows != nil && selectedRows!.contains(indexPath)) {
            handleCell?.addCheckMark(false)
        }
        
        return cell
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
            let handleCell: HandleTableViewCell? = tableView.cellForRowAtIndexPath(indexPath) as? HandleTableViewCell
            handleCell?.addCheckMark(true)
            
            // Show start button once at least 1 friend has been invited.
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            let handleCell: HandleTableViewCell? = tableView.cellForRowAtIndexPath(indexPath) as? HandleTableViewCell
            handleCell?.removeCheckMark(true)
            
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
                let whiteboardController = segue.destinationViewController as! WhiteboardViewController
                whiteboardController.sketch = sketch!
            }
            ~>
            {
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
