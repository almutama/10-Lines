//
//  ColorPickerViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit
import QuartzCore

protocol ColorPickerViewControllerDelegate {
    /* Called when the user has selected a color using a color picker. */
    func didPickColor(color: UIColor)
}

class ColorPickerViewController: UICollectionViewController {
    
    /* Delegate to inform of color picking events. */
    var delegate: ColorPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup background color.
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
    }
    
    // MARK: - Collection view data source
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("colorCell", forIndexPath: indexPath)
        
        // Configure cell. Some custom visual things, like rounded corners.
        cell.layer.cornerRadius = 5
        if (cell.selectedBackgroundView == nil) {
            cell.selectedBackgroundView = UIView(frame: cell.bounds)
            cell.selectedBackgroundView!.backgroundColor = UIColor.clearColor()
            cell.selectedBackgroundView!.layer.borderColor = UIColor(white: 0.0, alpha: 0.3).CGColor
            cell.selectedBackgroundView!.layer.borderWidth = 4
        }
        
        // Set cell background color by iterating through rainbow.
        if (indexPath.row == 0) {
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        else if (indexPath.row == 1) {
            cell.backgroundColor = UIColor.darkGrayColor()
        }
        else if (indexPath.row == 2) {
            cell.backgroundColor = UIColor.blackColor()
        }
        else {
            let offset = Double(indexPath.row - 3) / 24.0 * 2 * M_PI
            let red: CGFloat = CGFloat(sin(offset) * 0.5 + 0.5)
            let green: CGFloat = CGFloat(sin(offset + 2) * 0.5 + 0.5)
            let blue: CGFloat = CGFloat(sin(offset + 4) * 0.5 + 0.5)
            cell.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (self.delegate != nil) {
            let color = collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor
            self.delegate?.didPickColor(color!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
