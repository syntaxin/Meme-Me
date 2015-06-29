//
//  ViewController.swift
//  meme-me
//
//  Created by Enrico Montana on 4/12/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    // Declare all the items needed for creating this MemeMe application
    
    var selectedImage: UIImage!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var memeToolbar: UIToolbar!
    
    // Set the font for the meme lines
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSBackgroundColorAttributeName : UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 35)!,
        NSStrokeWidthAttributeName : -3
    ]
    
    
    //Get the View ready
    override func viewWillAppear(animated: Bool) {
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.tabBarController?.tabBar.hidden = true
        self.subscribeToKeyboardShowNotifications()
        self.subscribeToKeyboardHideNotifications()
        memeToolbar.hidden = false
        
    }
    
    //When leaving the view, stop listening for keyboard events
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardShowNotifications()
        self.unsubscribeFromKeyboardHideNotifications()
        memeToolbar.hidden = true
    }
    
    
    //Set the state for the starting point of the application
    
    override func viewDidLoad() {
        
        self.shareButton.enabled = false
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
    
    
    //Pick an image for use
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    //Take an image for use
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    //Choosing an image from the image picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            pickedImage.contentMode = .ScaleAspectFit
            pickedImage.image = chosenImage
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.shareButton.enabled = true
        topText.hidden = false
        bottomText.hidden = false

        
    }
    
    //Canceling your choice for an image
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.shareButton.enabled = false
        topText.hidden = true
        bottomText.hidden = true


    }
    
    
    //Share the amazing Meme that was just created
    @IBAction func shareMeme(sender: AnyObject) {
    
        let imageToShare = generateMemedImage()
        let messageText = "Check out this amazing meme created by Meme Me"
        let memeToShare = [imageToShare,messageText]
        let activityVC = UIActivityViewController(activityItems: memeToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if success == false {
                let savedMemesCollection = self.storyboard!.instantiateViewControllerWithIdentifier("InitialTabController")! as! UITabBarController
                self.navigationController!.presentViewController(savedMemesCollection, animated: true, completion: nil)
                activityVC.dismissViewControllerAnimated(true, completion: nil)
            }
            
            if success == true {
                self.saveMeme()
                let savedMemesCollection = self.storyboard!.instantiateViewControllerWithIdentifier("InitialTabController")! as! UITabBarController
                self.navigationController!.presentViewController(savedMemesCollection, animated: true, completion: nil)
                activityVC.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        
        self.navigationController?.presentViewController(activityVC, animated: true, completion: nil)
    
    
    }

 //Save memes and generate the flattened meme images
    
    func saveMeme(){
    
        let memedImage = generateMemedImage()
        let memeToSave = Meme(topLine: topText.text, bottomLine: bottomText.text, originalImage: pickedImage.image!, memeImage: memedImage)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memeList.append(memeToSave)
        memeToolbar.hidden = false
        
        //println( (UIApplication.sharedApplication().delegate as! AppDelegate).memeList.count)
    
    }
    
    func generateMemedImage() -> UIImage
    {
        //hide toolbar
        memeToolbar.hidden = true
        

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show toolbar again
        memeToolbar.hidden = false
        
        return memedImage
    }

 
    
//TextField delegates for controlling the text inputs
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.placeholder = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
//Keyboard listeners and functions for adjusting the view while editing
    
    func keyboardWillShow(notification: NSNotification){
    
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }

    
    func subscribeToKeyboardShowNotifications() {
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object:nil)
    
    }
    
    func unsubscribeFromKeyboardShowNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object:nil)
        
    }
    
    func unsubscribeFromKeyboardHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}

