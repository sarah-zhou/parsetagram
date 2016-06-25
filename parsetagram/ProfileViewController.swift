//
//  ProfileViewController.swift
//  parsetagram
//
//  Created by Sarah Zhou on 6/20/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var noProfPicImageView: UIImageView!
    @IBOutlet weak var profPicImageView: PFImageView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!

    let imagePicker = UIImagePickerController()
    var user : PFUser?
    
    var posts : [Post] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func chooseProfPic(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            self.performSegueWithIdentifier("logOut", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = PFUser.currentUser()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        bioTextView.delegate = self
        imagePicker.delegate = self
        
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)

        let user = PFUser.currentUser()
        usernameLabel.text = user!.username
        
        logOutButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica", size: 15.0)!], forState: UIControlState.Normal)
        
        let bio = user!["bio"] as? String
        if bio == "" {
            bioTextView.text = "Write a quick bio so people can get to know you!"
            bioTextView.textColor = UIColor.lightGrayColor()
        } else {
            bioTextView.text = bio
        }
        
        noProfPicImageView.layer.borderWidth = 1
        noProfPicImageView.layer.masksToBounds = false
        noProfPicImageView.layer.borderColor = UIColor.blackColor().CGColor
        noProfPicImageView.layer.cornerRadius = noProfPicImageView.frame.height/2
        noProfPicImageView.clipsToBounds = true

        profPicImageView.layer.borderWidth = 1
        profPicImageView.layer.masksToBounds = false
        profPicImageView.layer.borderColor = UIColor.blackColor().CGColor
        profPicImageView.layer.cornerRadius = profPicImageView.frame.height/2
        profPicImageView.clipsToBounds = true
        
        if let pic = user!["profilepic"] as? PFFile {
            profPicImageView.file = pic
            profPicImageView.loadInBackground()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadDataFromNetwork()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataFromNetwork() {
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    print("successfully retrieved things")
                    print(objects.count)

                    self.posts = Post.postArray(objects)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("currentUserPhotoCell", forIndexPath: indexPath) as! currentUserPhotoCell
        
        cell.postPhotoImageView.image = nil
        
        let post = posts[indexPath.row]
        
        cell.postPhotoImageView.file = post.media
        cell.postPhotoImageView.loadInBackground()
    
        return cell
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.darkGrayColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a quick bio so people can get to know you!"
            textView.textColor = UIColor.lightGrayColor()
            user!["bio"] = ""
            user?.saveInBackground()
        } else {
            user!["bio"] = bioTextView.text
            user?.saveInBackground()
        }
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let size = CGSize(width: 300.0, height: 300.0)
            let resizedImage = resize(pickedImage, newSize: size)
            
            profPicImageView.image = resizedImage
            let file = Post.getPFFileFromImage(resizedImage)
            user!["profilepic"] = file
            user!.saveInBackground()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailViewController" {
            let cell = sender as! currentUserPhotoCell
            let indexPath = collectionView.indexPathForCell(cell)
            let postPhoto = posts[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.postPhoto = postPhoto
        }
    }
}
