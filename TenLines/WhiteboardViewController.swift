//
//  WhiteboardViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit
import QuartzCore

class WhiteboardViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Programmatically set rounded corners on buttons.
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 10
        undoButton.layer.masksToBounds = true
        undoButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "popoverSegue") {
            // NOT WORKING YET - trying to present view controller as popover instead of new view
            let popoverViewController = segue.destinationViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
}
