//
//  WhiteboardViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit
import QuartzCore

class WhiteboardViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickerViewControllerDelegate, LineWidthPickerViewControllerDelegate {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    var remainingUndoCount: Int = 3
    
    @IBAction func undo(sender: AnyObject) {
        // Perform undo
        let whiteboard = view as! WhiteboardView
        if (whiteboard.undo()) {
            // Update undo button
            remainingUndoCount--;
            let title = "Undo (\(remainingUndoCount))"
            undoButton.setTitle(title, forState: UIControlState.Normal)
            undoButton.enabled = (remainingUndoCount >= 1)
        }
    }
    
    func resetUndoButton() {
        let title = "Undo (\(remainingUndoCount))"
        undoButton.setTitle(title, forState: UIControlState.Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Programmatically set rounded corners on buttons.
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 10
        undoButton.layer.masksToBounds = true
        undoButton.layer.cornerRadius = 10
        
        // Reset undo
        resetUndoButton()
    }
    
    // Mark: - Color picker view controller delegate
    
    func didPickColor(color: UIColor) {
        let whiteboard = view as! WhiteboardView
        whiteboard.currentColor = color
    }
    
    // Mark: - Line width picker view controller delegate
    
    func didPickLineWidth(width: Int) {
        let whiteboard = view as! WhiteboardView
        whiteboard.currentLineWidth = width
    }

    // MARK: - Navigation
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showColorPicker") {
            // NOT WORKING YET - trying to present view controller as popover instead of new view
            // See http://richardallen.me/2014/11/28/popovers.html. Is this an iOS9 issue, maybe?
            let popoverViewController = segue.destinationViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            
            // Set color picking callback delegate.
            let colorPickerViewController = popoverViewController as! ColorPickerViewController
            colorPickerViewController.delegate = self
        }
        else if (segue.identifier == "showLineWidthPicker") {
            let popoverViewController = segue.destinationViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            
            // Set color picking callback delegate.
            let lineWidthPickerViewController = popoverViewController as! LineWidthPickerViewController
            lineWidthPickerViewController.delegate = self
        }
    }
}
