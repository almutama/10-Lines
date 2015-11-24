//
//  ViewController.swift
//  TenLines
//
//  Created by Ben-han on 11/14/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var handle: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Rounded corners for begin button.
        beginButton.clipsToBounds = true;
        beginButton.layer.cornerRadius = 75;
        
        // Center items horizontally.
        logoImageView.center = CGPoint.init(x: self.view.frame.width / 2, y: logoImageView.center.y);
        beginButton.center = CGPoint.init(x: self.view.frame.width / 2, y: beginButton.center.y);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

