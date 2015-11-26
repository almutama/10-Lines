//
//  WhiteboardView.swift
//  TenLines
//
//  Created by Ben-han on 11/26/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import Foundation
import UIKit

class WhiteboardView: UIView {
    
    var lines: Array<Line> = Array<Line>()
    var currentLine: Line?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentLine = Line()
        let touchPoint = touches.first?.locationInView(self)
        currentLine?.points += [touchPoint!]
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchPoint = touches.first?.locationInView(self)
        currentLine?.points += [touchPoint!]
        self.setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        currentLine = nil
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lines += [currentLine!]
        currentLine = nil
        self.setNeedsDisplay()
    }
    
    func drawLine(line: Line) {
        // Build (graphical) line.
        let path = UIBezierPath()
        path.moveToPoint(line.points[0])
        for point in line.points {
            path.addLineToPoint(point)
        }
        
        // Set stroke color to line color.
        line.color.setStroke()
        
        // Draw line.
        path.stroke()
    }
    
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
}