//
//  UploadViewController.swift
//  parsetagram
//
//  Created by Sarah Zhou on 6/20/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var missingPhotoLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    var actualCaption : String?
    
    @IBAction func cameraRoll(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camera(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadPhoto(sender: AnyObject) {
        if uploadImageView.image == nil {
            captionLabel.hidden = true
            shareLabel.hidden = true
            missingPhotoLabel.hidden = false
        } else {
            if captionTextView.text == "Funny, witty, adorable, or meaningful caption here" {
                actualCaption = ""
            } else {
                actualCaption = captionTextView.text
            }
            
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let localDate = dateFormatter.stringFromDate(date)
            
            // Display HUD right before the request is made
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            Post.postUserImage(uploadImageView.image!, withCaption: actualCaption, withDate: localDate) { (success : Bool, error : NSError?) in
                if success {
                    print("new post saved")
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.initializeScreen()
                    self.tabBarController?.selectedIndex = 0
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeScreen()
    }
    
    func initializeScreen() {
        
        captionTextView.delegate = self
        captionTextView.text = "Funny, witty, adorable, or meaningful caption here"
        captionTextView.textColor = UIColor.lightGrayColor()
        
        captionLabel.hidden = false
        shareLabel.hidden = true
        missingPhotoLabel.hidden = true
        
        uploadImageView.image = nil
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UploadViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UploadViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let size = CGSizeMake(500.0, 500.0)
            let resizedImage = resize(pickedImage, newSize: size)
            
            uploadImageView.image = resizedImage
            captionLabel.hidden = false
            shareLabel.hidden = true
            missingPhotoLabel.hidden = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Insert funny, witty, adorable, or meaningful caption here"
            textView.textColor = UIColor.lightGrayColor()
            captionLabel.hidden = false
            shareLabel.hidden = true
            missingPhotoLabel.hidden = true
        } else {
            captionLabel.hidden = true
            shareLabel.hidden = false
            missingPhotoLabel.hidden = true
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
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