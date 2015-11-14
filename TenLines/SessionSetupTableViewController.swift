//
//  SessionSetupTableViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class SessionSetupTableViewController: UITableViewController {

    private var friends: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up refresh callback.
        self.refreshControl?.addTarget(self, action: "refreshFriends:", forControlEvents: UIControlEvents.ValueChanged)
        
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
        friends = JSON(data: NSData(contentsOfFile: path!)!)
        
        // Hide the loading indicator since we're done loading.
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends != nil ? friends!.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = friends![indexPath.row]["firstname"].string

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
