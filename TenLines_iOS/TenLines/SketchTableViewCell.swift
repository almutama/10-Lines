//
//  SketchTableViewCell.swift
//  TenLines
//
//  Created by Ben-han Sung on 5/7/16.
//  Copyright © 2016 Art Attack. All rights reserved.
//

import Foundation
import UIKit

class SketchTableViewCell : UITableViewCell {
    @IBOutlet var preview : UIImageView?
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var infoLabel : UILabel?
    @IBOutlet var upvoteButton : UIButton?
    @IBOutlet var commentButton : UIButton?
    
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
    }
    
    func configureForSketch(sketch: Sketch?) {
        guard let sketch = sketch else {
            return
        }
        
        // Upvote button.
        //self.upvoteButton?.addTarget(self, action:"upvote:", forControlEvents: UIControlEvents.TouchUpInside);
        self.upvoteButton?.setTitle(String(sketch.upvotes!), forState: UIControlState.Normal)
        
        // Comments button.
        self.commentButton?.setTitle(String(sketch.comments!), forState: UIControlState.Normal);
        
        // Line count label.
        self.infoLabel?.text = "\(sketch.artists!) artists, \(sketch.lines!) lines"
        
        // Sketch title label.
        self.titleLabel?.text = sketch.title!
        
        // Load image.
        self.preview?.image = UIImage(named: "sketch_placeholder.png")
        guard (sketch.image != nil) else {
            // Fetch the image on a background thread, then show it.
            // The first block here denotes something done on a background thread.
            // The second block denotes something to do after the first block completes.
            // See Threading.swift for details on how this works.
            { sketch.loadImage() } ~> { if (sketch.image != nil) { self.preview?.image = sketch.image } }
            return
        }
        self.preview?.image = sketch.image
    }
}
