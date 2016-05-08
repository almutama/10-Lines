//
//  HandleTableViewCell.swift
//  TenLines
//
//  Created by Ben-han Sung on 5/7/16.
//  Copyright © 2016 Art Attack. All rights reserved.
//

import Foundation
import UIKit

class HandleTableViewCell : UITableViewCell {
    
    @IBOutlet var preview: UIImageView?
    @IBOutlet var handleLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCustomVisualProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupCustomVisualProperties()
    }

    func setupCustomVisualProperties() {
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
    }
    
    func configureForSketch(sketch: Sketch?) {
        guard let sketch = sketch else {
            return
        }
        
        // Remove old state, if any.
        removeCheckMark(false)
        
        // Name label.
        self.handleLabel?.text = sketch.creator! + " invited you!"
        
        // Preview picture.
        self.preview?.image = UIImage(named: "sketch_placeholder.png");
        guard sketch.image != nil else {
            { sketch.loadImage() } ~> { if (sketch.image != nil) { self.preview?.image = sketch.image } }
            return
        }
        self.preview?.image = sketch.image
    }
    
    func configureForArtist(artist: Artist?) {
        guard let artist = artist else {
            return
        }
        
        // Remove old state, if any.
        removeCheckMark(false)
        
        // Name label.
        handleLabel?.text = (artist.firstname == nil) ? artist.username : artist.firstname
        
        // Profile picture.
        guard artist.icon != nil else {
            { artist.loadIcon() } ~> { if (artist.icon != nil) { self.preview?.image = artist.icon } }
            return
        }
        self.preview?.image = artist.icon
    }
    
    func addCheckMark(animated: Bool) {
        guard let iconImageView = self.preview else {
            return
        }
        
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
        self.accessoryView = accessoryView
        
        // Animate it.
        let duration = (animated) ? 0.3 : 0.0
        UIView.animateWithDuration(duration) {
            overlayView.center = CGPoint(x: iconImageView.frame.size.width / 2, y: iconImageView.frame.size.height / 2)
            overlayView.frame = iconImageView.bounds
            checkmark.frame = overlayView.bounds
            self.accessoryView!.frame = CGRect(x: 0, y: 0, width: 30, height: 10)
        }
    }
    
    func removeCheckMark(animated: Bool) {
        guard let iconImageView = self.preview else {
            return
        }
        
        let _ = iconImageView.subviews.map({subview in subview.removeFromSuperview()})
        self.accessoryView = nil
    }
}
