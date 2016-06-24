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
    @IBOutlet weak var profPicImageView: UIImageView!
    
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
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        otherCollectionView.insertSubview(refreshControl, atIndex: 0)
        
        usernameLabel.text = user?.username
        bioLabel.text = user?["bio"] as? String
        profPicImageView.image = user?["profilepic"] as? UIImage
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
                    print("other user successfully retrieved things")
                    print(objects.count)
                    
                    self.posts = Post.postArray(objects)
                    for var post in self.posts {
                        let img = post.obj!["media"] as! PFFile
                        img.getDataInBackgroundWithBlock({ (data, error) in
                            if let image = UIImage(data: data!) {
                                print("profile successfully downloaded image")
                                post.img = image
                                self.otherCollectionView.reloadData()
                            } else {
                                print("error downloading image: " + error!.localizedDescription)
                            }
                            
                        })
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        self.loadDataFromNetwork()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("otherPhotoCell", forIndexPath: indexPath) as! otherPhotoCell
        
        let post = posts[indexPath.row]
        
        if post.img != nil {
            cell.postPhotoImageView.image = post.img
        }
        
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
