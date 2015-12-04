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
    
    /* Short poll timer. */
    var timer: NSTimer?
    
    /* The sketch currently being modified/created by this controller. */
    var sketch: Sketch?
    
    deinit {
        timer?.invalidate()
    }
    
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
        
        // Create the sketch if it wasn't set by the segue.
        /*
        if (self.sketch == nil) {
            ({ self.sketch = AccountManager.sharedManager.createSketchWithTitle("Untitled") } ~> {})
        }*/
        
        // Start short polling
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "shortPoll:", userInfo: nil, repeats: true)
        
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
    
    /* Short polling for more lines. LOLZ. Beause not enough time to 
     * implement web sockets. */
    func shortPoll(sender: AnyObject?) {
        ({ AccountManager.sharedManager.syncLinesForSketch(self.sketch!) }
        ~>
        {
            // Update whiteboard if we received new lines.
            let whiteboard = self.view as! WhiteboardView
            if (self.sketch!.lineData.count > whiteboard.lines.count) {
                whiteboard.lines = self.sketch!.lineData
                whiteboard.setNeedsDisplay()
            }
        })
    }
    
    // Mark: - Whiteboard view delegate
    
    func didDrawLine(line: Line) {
        let whiteboard = view as! WhiteboardView
        let lineCount = max(0, 10 - whiteboard.lines.count)
        instructionLabel.text = "\(lineCount) lines left. your turn!"
        
        // Notify other participants of new line.
        ({ AccountManager.sharedManager.addlineToSketch(line, sketch: self.sketch!) } ~> {})
        
        // Update screenshot.
        ({
            let screenshot: UIImage = whiteboard.getScreenshot()!
            AccountManager.sharedManager.addScreenshotForSketch(screenshot, sketch: self.sketch!)
        }
        ~>
        {})
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
}
