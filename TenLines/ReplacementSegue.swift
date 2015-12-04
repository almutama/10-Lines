//
//  ReplacementSegue.swift
//  TenLines
//
//  Created by Ben-han on 12/4/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class ReplacementSegue: UIStoryboardSegue {
    override func perform() {
        // Grab variables for readability.
        let sourceViewController: UIViewController = self.sourceViewController
        let destinationViewController: UIViewController = self.destinationViewController
        let navigationController: UINavigationController = sourceViewController.navigationController!
        
        // Get a changeable copy of the stack.
        let controllerStack: NSMutableArray = NSMutableArray(array: navigationController.viewControllers)
        // Replace the source controller with the destination controller, wherever the source may be.
        controllerStack.replaceObjectAtIndex(controllerStack.indexOfObject(sourceViewController), withObject: destinationViewController)
        
        // Assign the updated stack with animation
        navigationController.setViewControllers(controllerStack as AnyObject as! [UIViewController], animated: true)
    }
}
