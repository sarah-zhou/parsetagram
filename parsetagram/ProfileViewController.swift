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

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var posts : [Post] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            let Login = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(Login, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadDataFromNetwork()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)

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
                    for var post in self.posts {
                        print("loop")
                        let img = post.obj!["media"] as! PFFile
                        img.getDataInBackgroundWithBlock({ (data, error) in
                            if let image = UIImage(data: data!) {
                                print("profile successfully downloaded image")
                                post.img = image
                                self.collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("currentUserPhotoCell", forIndexPath: indexPath) as! currentUserPhotoCell
        
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
