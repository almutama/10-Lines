//
//  FinishedSketchViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/30/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit
import QuartzCore

class FinishedSketchViewController: UITableViewController {
    
    /* List of artists you drew with. */
    var artists: Array<Artist>?
    
    /* Button that takes user back to home feed. */
    @IBOutlet weak var homeButton: UIButton!
    
    /* Image view displaying the completed sketch. */
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table view cell class.
        let cellNib: UINib? = UINib(nibName: "HandleTableViewCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "handleCell")

        // Load image.
        self.imageView.image = self.image
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).CGColor
        self.imageView.layer.borderWidth = 1
        
        // Center new sketch button.
        self.homeButton.clipsToBounds = true;
        self.homeButton.layer.cornerRadius = 65;
        self.homeButton.center = CGPoint.init(x: self.view.frame.width / 2, y: homeButton.center.y);
        
        // Temporary load feed data from a file. Eventually we want to get this
        // data by invoking a web service instead.
        let path = NSBundle.mainBundle().pathForResource("friends2", ofType: "json")
        let data = JSON(data: NSData(contentsOfFile: path!)!)
        self.artists = Artist.fromJSON(data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goHome(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.selectedBackgroundView = nil
        return cell
    }
    
    func friendCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("handleCell", forIndexPath: indexPath)
        let handleCell: HandleTableViewCell? = cell as? HandleTableViewCell
        let artist: Artist? = artists?[indexPath.row]
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
            return "Update title"
        }
        else {
            return "Add sketch buddies to friends"
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
            let handleCell: HandleTableViewCell? = tableView.cellForRowAtIndexPath(indexPath) as? HandleTableViewCell
            handleCell?.addCheckMark(true)
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            let handleCell: HandleTableViewCell? = tableView.cellForRowAtIndexPath(indexPath) as? HandleTableViewCell
            handleCell?.removeCheckMark(true)
        }
    }

}
