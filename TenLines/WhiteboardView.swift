//
//  WhiteboardView.swift
//  TenLines
//
//  Created by Ben-han on 11/26/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

protocol WhiteboardViewDelegate {
    /* Callback method to inform delegates that a new line has been drawn. */
    func didDrawLine(line: Line)
}

class WhiteboardView: UIView {
    
    var lines: Array<Line> = Array<Line>()
    var currentLine: Line?
    var currentColor: UIColor = UIColor.blackColor()
    var currentLineWidth: Int = 3
    
    var delegate: WhiteboardViewDelegate?
    
    /* Call to undo last drawn line. There is no redo functionality so undos
       are permanent. */
    func undo() -> Bool {
        if (lines.count > 0) {
            lines.removeLast()
            self.setNeedsDisplay()
            return true
        }
        self.setNeedsDisplay()
        return false
    }
    
    /* Called when the user touches the view. */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Create a new line.
        currentLine = Line()
        currentLine?.color = currentColor
        currentLine?.width = CGFloat(currentLineWidth)
        
        // Add current touch point.
        let touchPoint = touches.first?.locationInView(self)
        currentLine?.points += [touchPoint!]
        
        // Force redraw.
        self.setNeedsDisplay()
    }
    
    /* Called when the user drags their finger along the view. */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Add current touch point.
        let touchPoint = touches.first?.locationInView(self)
        currentLine?.points += [touchPoint!]
        
        // Force redraw.
        self.setNeedsDisplay()
    }
    
    /* Called when the user lifts their finger. */
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        currentLine = nil
        
        // Force redraw.
        self.setNeedsDisplay()
    }
    
    /* Called when the user lifts their finger. */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Save line.
        lines += [currentLine!]
        
        // Notify delegate of new line.
        if (delegate != nil) {
            delegate!.didDrawLine(currentLine!)
        }
        currentLine = nil
        
        // Force redraw.
        self.setNeedsDisplay()
    }
    
    /* Drawing callback. This is where you implement how the view is drawn. */
    override func drawRect(rect: CGRect) {
        // Draw lines.
        for line in lines {
            drawLine(line)
        }
        
        // Draw current line {
        if (self.currentLine != nil) {
            drawLine(self.currentLine!)
        }
    }
    
    /* Helper method to draw a single line. */
    func drawLine(line: Line) {
        // Build (graphical) line.
        let path = UIBezierPath()
        path.lineWidth = line.width
        path.moveToPoint(line.points[0])
        for point in line.points {
            path.addLineToPoint(point)
        }
        
        // Set stroke color to line color.
        line.color.setStroke()
        
        // Draw line.
        path.stroke()
    }
    
    /* Returns a screenshot of the drawing. */
    func getScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}