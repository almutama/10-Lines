//
//  Line.swift
//  TenLines
//
//  Created by Ben-han on 11/26/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import Foundation
import UIKit

class Line {
    var color: UIColor = UIColor.blackColor()
    var points: Array<CGPoint> = Array<CGPoint>()
    var width: CGFloat = 3
    
    /* Creates a Line object from a corresponding JSON fragment. */
    static func fromJSONFragment(object: JSON) -> Line {
        let line: Line = Line()
        line.color = UIColor.blackColor() // TODO: Serialize UIColor!
        line.width = CGFloat(object["width"].int!)
        
        // Deserialize points.
        let data: NSData = object["lines"].string!.dataUsingEncoding(NSUTF8StringEncoding)!
        line.points = Line.swiftArrayFromJSONArray(JSON(data: data).array!)
        
        return line
    }
    
    /* Creates a list of Line objects from a corresponding JSON fragment. */
    static func fromJSON(object: JSON) -> Array<Line> {
        var lines = Array<Line>()
        for (_, item) in object {
            lines += [fromJSONFragment(item)]
        }
        return lines
    }
    
    /* Converts an array of CGPoints into an NSArray of NSArrays. For use with
     * JSON serialization. */
    static func cocoaArrayFromSwiftArray(points: Array<CGPoint>) -> NSArray {
        let output = NSMutableArray()
        for point in points {
            let temp = NSMutableArray()
            temp.addObject(Float(point.x))
            temp.addObject(Float(point.y))
            output.addObject(temp)
        }
        return output
    }
    
    /* Converts an array of JSON entities into a Swift Array of CGPoints. For 
     * use with JSON deserialization. */
    static func swiftArrayFromJSONArray(points: [JSON]) -> Array<CGPoint> {
        var output = Array<CGPoint>()
        for point in points {
            let x: CGFloat = CGFloat(point[0].floatValue)
            let y: CGFloat = CGFloat(point[1].floatValue)
            output += [CGPoint(x: x, y: y)]
        }
        return output
    }
}