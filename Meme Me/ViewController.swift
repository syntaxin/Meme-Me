//
//  ViewController.swift
//  meme-me
//
//  Created by Enrico Montana on 4/12/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var selectedImage: UIImage!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var pickedImage: UIImageView!
    
    let memeTextAttributes = [
        //NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.blackColor(),
        //NSBackgroundColorAttributeName : UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSStrokeWidthAttributeName : 3
    ]
    
    
    override func viewWillAppear(animated: Bool) {
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //TODO: Unsubscribe
    }
    
    override func viewDidLoad() {
        
        self.topText.delegate = self
        self.bottomText.delegate = self
        topText.hidden = true
        bottomText.hidden = true
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        topText.placeholder = "Enter your meme"
        topText.borderStyle = UITextBorderStyle.None
        bottomText.textAlignment = .Center
        bottomText.borderStyle = UITextBorderStyle.None
        bottomText.placeholder = "Get to the point"
    }
    
    
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            pickedImage.contentMode = .ScaleAspectFit
            pickedImage.image = chosenImage
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        topText.hidden = false
        bottomText.hidden = false
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.placeholder = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //    func keyboardWillShow(notification: NSNotification){
    //
    //        if bottomText.isFirstResponder() {
    //            self.view.frame.origin.y -= getKeyboardHeight(notification)
    //        }
    //
    //    }
    //
    //    func subscribeToKeyboardNotifications() {
    //
    //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object:nil)
    //
    //    }
    //
    //    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    //        let userInfo = notification.userInfo
    //        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    //        return keyboardSize.CGRectValue().height
    //    }
}

