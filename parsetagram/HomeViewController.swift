//
//  HomeViewController.swift
//  parsetagram
//
//  Created by Sarah Zhou on 6/20/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var photosTableView: UITableView!
    
    var posts : [Post] = [] {
        didSet {
            self.photosTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadDataFromNetwork()
        
        photosTableView.dataSource = self
        photosTableView.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        photosTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    /*
    override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        self.loadDataFromNetwork()
    }
 */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataFromNetwork() {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("successfully retrieved things")
                if let objects = objects {
                    self.posts = Post.postArray(objects)
                    for var post in self.posts {
                        let img = post.obj!["media"] as! PFFile
                        img.getDataInBackgroundWithBlock({ (data, error) in
                            if let image = UIImage(data: data!) {
                                print("successfully downloaded image")
                                post.img = image
                                self.photosTableView.reloadData()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = photosTableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        cell.selectionStyle = .None
        
        let post = posts[indexPath.row]
        if let user = post.obj!["author"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "NO USER"
        }
        
        cell.photoView.image = post.img

        return cell
    }
    
    
    // change of segue from cell to button 
    // how to pass information through a button
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailViewController" {
            let button = sender as! UIButton
            let contentView = button.superview! as UIView
            let cell = contentView.superview as! PhotoCell
            let indexPath = photosTableView.indexPathForCell(cell)
            let postPhoto = posts[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.postPhoto = postPhoto
        }
    }
}
