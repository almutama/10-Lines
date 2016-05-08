//
//  RegistrationViewController.swift
//  TenLines
//
//  Created by Ben-han on 12/5/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Dismisses this registration controller. */
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* Presents an image picker view controller to the user so
     * they can pick a profile picture. */
    @IBAction func pickProfilePicture(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .Camera
        imagePickerController.cameraCaptureMode = .Photo
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    /* Registers a new user. */
    @IBAction func registerNewUser(sender: AnyObject) {
        if (self.usernameTextField.text != nil && self.passwordTextField.text != nil &&
            self.usernameTextField.text != "") {
                // Fetch user details
                let username = self.usernameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let password = self.passwordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let image = self.profilePictureButton.backgroundImageForState(UIControlState.Normal)
                
                var success: Bool = false
                ({ success = AccountManager.sharedManager.register(username, password: password, image: image) }
                ~>
                {
                    if (success) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainNavigationController = storyboard.instantiateViewControllerWithIdentifier("mainNavigationController")
                        self.presentViewController(mainNavigationController, animated: true, completion: nil)
                    }
                })
        }
    }
    
    // MARK: - Picker controller delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Compute crop rect.
            var cropRect: CGRect?
            if (pickedImage.size.height > pickedImage.size.width) {
                cropRect = CGRect(x: 0, y: pickedImage.size.height / 2 - pickedImage.size.width / 2,
                                  width: pickedImage.size.width, height: pickedImage.size.width)
            }
            else {
                cropRect = CGRect(x: pickedImage.size.width / 2 - pickedImage.size.height / 2, y: 0,
                    width: pickedImage.size.height, height: pickedImage.size.height)
            }
            
            // Crop image.
            let imageRef: CGImageRef? = CGImageCreateWithImageInRect(pickedImage.CGImage, cropRect!);
            let croppedImage = UIImage(CGImage: imageRef!, scale: 0.00001, orientation: pickedImage.imageOrientation)
            profilePictureButton.setBackgroundImage(croppedImage, forState: UIControlState.Normal)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
