//
//  ProfileViewController.swift
//  TenLines
//
//  Created by Nyasha on 12/4/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    @IBOutlet var profilePictureView: UIImageView?
    @IBOutlet var userNameLabel: UILabel?
    
    // List of sketches currently displayed in feed.
    private var feedItems: Array<Sketch>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table view cell class.
        let cellNib: UINib? = UINib(nibName: "SketchTableViewCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "sketchCell")

        // Setup refresh callback.
        self.refreshControl?.addTarget(self, action: #selector(ProfileViewController.refreshFeed(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Load profile picture.
        self.profilePictureView?.image = UIImage(named: "profile_placeholder.png")
        ({ self.profilePictureView?.image = AccountManager.sharedManager.getUserPic() } ~> {})
        
        // Load user name.
        self.userNameLabel?.text = AccountManager.sharedManager.username
        
        // Load feed immediately.
        self.refreshFeed(nil)
    }
    
    func refreshFeed(sender: AnyObject?) {
        ({ self.feedItems = AccountManager.sharedManager.getAllSketches() }
        ~>
        {
            // Hide the loading indicator since we're done loading.
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true);
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 325;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems != nil ? feedItems!.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sketchCell", forIndexPath: indexPath)
        let sketchCell: SketchTableViewCell? = cell as? SketchTableViewCell
        let sketch: Sketch? = feedItems?[indexPath.row]
        sketchCell?.configureForSketch(sketch)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showCommentsFromProfile", sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showCommentsFromProfile") {
            let path = self.tableView.indexPathForSelectedRow
            let commentController = segue.destinationViewController as! CommentController
            commentController.sketch = feedItems![path!.row]
        }
    }
}
