//
//  Sketch.swift
//  TenLines
//
//  Created by Ben-han on 11/24/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import Foundation
import UIKit

class Sketch {
    var title: String = ""
    var url: String = ""
    var lines: Int = 0
    var upvotes: Int = 0
    var comments: Array<Comment> = Array<Comment>()
    var artists: Array<String> = Array<String>()
    var image: UIImage?
    
    /* Upvotes this sketch. */
    func upvote(sender: AnyObject) {
        upvotes++
    }
    
    /* Adds a comment to this sketch. */
    func addComment(comment: Comment) {
        comments += [comment]
    }
    
    /* Loads this sketch's image, SYNCHRONOUSLY. */
    func loadImage() {
        let data: NSData? = NSData(contentsOfURL: NSURL(string: url)!)
        self.image = UIImage(data: data!)
    }
    
    /* Creates a Sketch object from a corresponding JSON fragment. */
    static func fromJSONFragment(object: JSON) -> Sketch {
        let sketch : Sketch = Sketch()
        sketch.title = object["title"].string!
        sketch.url = object["url"].string!
        sketch.lines = object["lines"].int!
        sketch.upvotes = object["upvotes"].int!
        
        // Aggregate comments
        sketch.comments = Comment.fromJSON(object["comments"])
        
        // Aggregate artists
        for (_, artist) in object["artists"] {
            sketch.artists += [artist.string!]
        }
        
        return sketch
    }
    
    /* Creates a list of Sketch objects from a corresponding JSON fragment. */
    static func fromJSON(object: JSON) -> Array<Sketch> {
        var sketches = Array<Sketch>()
        for (_, item) in object {
            sketches += [fromJSONFragment(item)]
        }
        return sketches
    }
}