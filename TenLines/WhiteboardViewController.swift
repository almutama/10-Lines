//
//  WhiteboardViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit
import QuartzCore

class WhiteboardViewController: UIViewController, UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate, WhiteboardViewDelegate, ColorPickerViewControllerDelegate, LineWidthPickerViewControllerDelegate {

    @IBOutlet weak var colorPickerButton: UIBarButtonItem!
    @IBOutlet weak var lineWidthButton: UIBarButtonItem!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    weak var presentingBarButtonItem: UIBarButtonItem?
    
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

        // Set whiteboard delegate.
        let whiteboard = view as! WhiteboardView
        whiteboard.delegate = self
        
        // Programmatically set rounded corners on buttons.
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 10
        undoButton.layer.masksToBounds = true
        undoButton.layer.cornerRadius = 10
        
        // Reset undo
        resetUndoButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true);
    }
    
    // Mark: - Whiteboard view delegate
    
    func didDrawLine(line: Line) {
        let whiteboard = view as! WhiteboardView
        let lineCount = max(0, 10 - whiteboard.lines.count)
        instructionLabel.text = "\(lineCount) lines left. your turn!"
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
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = .Any
        popoverPresentationController.barButtonItem = presentingBarButtonItem
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    @IBAction func finished(sender: AnyObject) {
        let alert = UIAlertController(title: "Heads up!", message: "Are you sure you're done?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yep!", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("finishedViewController")
            
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0);
            let context = UIGraphicsGetCurrentContext()
            self.view.layer.renderInContext(context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let finishedViewController = destinationViewController as! FinishedSketchViewController
            finishedViewController.image = image
            
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Nope!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func presentLineWidthPicker(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let lineWidthPickerViewController = storyboard.instantiateViewControllerWithIdentifier("lineWidthPicker") as! LineWidthPickerViewController
        
        lineWidthPickerViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        lineWidthPickerViewController.popoverPresentationController!.delegate = self
        lineWidthPickerViewController.delegate = self
        
        self.presentingBarButtonItem = lineWidthButton
        self.presentViewController(
            lineWidthPickerViewController,
            animated: true,
            completion: nil)
    }
    
    @IBAction func presentColorPicker(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let colorPickerViewController = storyboard.instantiateViewControllerWithIdentifier("colorPicker") as! ColorPickerViewController
        
        colorPickerViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        colorPickerViewController.popoverPresentationController!.delegate = self
        colorPickerViewController.delegate = self
        
        self.presentingBarButtonItem = colorPickerButton
        self.presentViewController(
            colorPickerViewController,
            animated: true,
            completion: nil)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
