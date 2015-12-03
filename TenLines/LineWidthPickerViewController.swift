//
//  LinePickerViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/29/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

protocol LineWidthPickerViewControllerDelegate {
    /* Called when the user has selected a color using a color picker. */
    func didPickLineWidth(width: Int)
}

class LineWidthPickerViewController: UITableViewController {

    /* Delegate to inform of line width picking events. */
    var delegate: LineWidthPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lineWidthCell", forIndexPath: indexPath)

        // Configure the cell...
        if (cell.selectedBackgroundView == nil) {
            cell.selectedBackgroundView = UIView(frame: cell.bounds)
            cell.selectedBackgroundView!.backgroundColor = UIColor.clearColor()
            cell.selectedBackgroundView!.layer.borderColor = UIColor(white: 0.0, alpha: 0.7).CGColor
            cell.selectedBackgroundView!.layer.borderWidth = 4
        }
        
        // Customize line-width preview.
        let lineView = cell.viewWithTag(10)!
        lineView.frame.size = CGSizeMake(lineView.frame.width, CGFloat(3 + 3 * indexPath.row))
        lineView.center = CGPointMake(lineView.center.x, cell.bounds.size.height / 2 - lineView.frame.size.height / 2)

        return cell
    }

    // MARK: - Navigation

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.delegate != nil) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            let lineView = cell.viewWithTag(10)!
            self.delegate!.didPickLineWidth(Int(lineView.frame.size.height))
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
