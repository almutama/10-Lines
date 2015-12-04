//
//  FinishedSketchViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/30/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class FinishedSketchViewController: UITableViewController {

    /* List of artists you drew with. */
    var artists: Array<Artist>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Temporary load feed data from a file. Eventually we want to get this
        // data by invoking a web service instead.
        let path = NSBundle.mainBundle().pathForResource("friends2", ofType: "json")
        let data = JSON(data: NSData(contentsOfFile: path!)!)
        artists = Artist.fromJSON(data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
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
        let artist = artists![indexPath.row]
        
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
            return "Update description"
        }
        else {
            return "Add new friends"
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
            return 75
        }
        return 120
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        return artists != nil ? artists!.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            return textCellForIndexPath(indexPath)
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
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            removeCheckMarkFromCell(cell!, animated: true)
        }
    }

}
