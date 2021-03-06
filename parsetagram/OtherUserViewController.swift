//
//  OtherUserViewController.swift
//  parsetagram
//
//  Created by Sarah Zhou on 6/22/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class OtherUserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var otherCollectionView: UICollectionView!
    @IBOutlet weak var otherFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var profPicImageView: PFImageView!
    @IBOutlet weak var noProfPicImageView: UIImageView!
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    var user : PFUser!
    var posts : [Post] = [] {
        didSet {
            self.otherCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadDataFromNetwork()
        
        otherCollectionView.dataSource = self
        otherCollectionView.delegate = self
        
        otherFlowLayout.scrollDirection = .Vertical
        otherFlowLayout.minimumLineSpacing = 2
        otherFlowLayout.minimumInteritemSpacing = 2
        otherFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    
        usernameLabel.text = user?.username
        
        let bio = user!["bio"] as? String
        if bio == "" {
            bioLabel.text = "Lol this user did not set a bio. I wonder how long it will take for them to find out that this is the default bio if you do not set one."
        } else {
            bioLabel.text = bio
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataFromNetwork() {
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: user)
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.posts = Post.postArray(objects)
                } else {
                print(error?.localizedDescription)
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("otherPhotoCell", forIndexPath: indexPath) as! otherPhotoCell
        
        let post = posts[indexPath.row]
        
        cell.postPhotoImageView.file = post.obj!["media"] as! PFFile
        cell.postPhotoImageView.loadInBackground()
        
        return cell
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
