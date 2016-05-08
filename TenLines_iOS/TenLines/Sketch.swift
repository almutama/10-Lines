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
    var id: Int?
    var title: String?
    var lines: Int?
    var upvotes: Int?
    var comments: Int?
    var artists: Int?
    var creator: String?
    var lineData: Array<Line> = Array<Line>()
    var image: UIImage?
    
    /* Default initializer. */
    init() {
        self.id = -1
    }
    
    /* Init with sketch id. */
    init(id: Int) {
        self.id = id
    }
    
    /* Upvotes this sketch. */
    func upvote(sender: AnyObject) {
        self.upvotes? += 1
    }
    
    /* Loads this sketch's image, SYNCHRONOUSLY. */
    func loadImage() {
        self.image = AccountManager.sharedManager.getSketch(self.id!)
    }
    
    /* Creates a Sketch object from a corresponding JSON fragment. */
    static func fromJSONFragment(object: JSON) -> Sketch {
        let sketch : Sketch = Sketch()
        sketch.id = object["id"].int
        sketch.title = object["title"].string
        sketch.lines = object["lines"].int
        sketch.upvotes = object["upvotes"].int
        sketch.comments = object["comments"].int
        sketch.creator = object["creator"].string
        sketch.artists = object["artists"].int
        
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