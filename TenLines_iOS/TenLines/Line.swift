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
        
        // Deserialize line.
        line.points = Line.deserializePoints(object["lines"].string!)
        line.color = Line.deserializeColor(object["color"].string!)
        line.width = CGFloat(object["width"].float!)
        
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
    
    /* Serializes a UIColor to a JSON string. */
    static func serializeColor(color: UIColor) throws -> NSString? {
        // Get color components
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Convert to JSON string.
        let output = NSMutableDictionary()
        output.setValue(Float(red), forKey: "red")
        output.setValue(Float(green), forKey: "green")
        output.setValue(Float(blue), forKey: "blue")
        output.setValue(Float(alpha), forKey: "alpha")
        let data = try NSJSONSerialization.dataWithJSONObject(output, options: NSJSONWritingOptions(rawValue: 0))
        return NSString(data: data, encoding: NSUTF8StringEncoding)
    }
    
    /* Deserializes a UIColor from JSON. */
    static func deserializeColor(color: String) -> UIColor {
        let data: JSON = JSON(data: color.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        let red = CGFloat(data["red"].float!)
        let green = CGFloat(data["green"].float!)
        let blue = CGFloat(data["blue"].float!)
        let alpha = CGFloat(data["alpha"].float!)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /* Serializes points to a JSON string. */
    static func serializePoints(points: Array<CGPoint>) throws -> NSString? {
        let output = NSMutableArray()
        for point in points {
            let temp = NSMutableArray()
            temp.addObject(Float(point.x))
            temp.addObject(Float(point.y))
            output.addObject(temp)
        }
        let data = try NSJSONSerialization.dataWithJSONObject(output, options: NSJSONWritingOptions(rawValue: 0))
        return NSString(data: data, encoding: NSUTF8StringEncoding)
    }
    
    /* Deserializes points from JSON. */
    static func deserializePoints(points: String) -> Array<CGPoint> {
        let data: JSON = JSON(data: points.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        var output = Array<CGPoint>()
        for (_, point) in data {
            let x: CGFloat = CGFloat(point[0].floatValue)
            let y: CGFloat = CGFloat(point[1].floatValue)
            output += [CGPoint(x: x, y: y)]
        }
        return output
    }
}