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
    
    var posts : [PFObject] = [] {
        didSet {
            self.photosTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosTableView.dataSource = self
        photosTableView.delegate = self
        
        self.loadDataFromNetwork()
        
        /*
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        photosTableView.insertSubview(refreshControl, atIndex: 0) */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataFromNetwork() {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.includeKey("image")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("successfully retrieved things")
                if let objects = objects {
                    self.posts = objects
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    /*
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let myRequest = loadDataFromNetwork()
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest, completionHandler: { (data, response, error) in
                                                                        
            // ... Use the new data to update the data source ...
                                                                        
            // Reload the tableView now that there is new data
            
            self.myTableView.reloadData()
                                                                        
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        });
        task.resume()
    } */
    
    /* func refresh() {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("successfully retrieved things")
                if let objects = objects {
                    self.posts = objects
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    } */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = photosTableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        cell.selectionStyle = .None
        
        let post = posts[indexPath.row] 
        if let user = post["author"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "NO USER"
        }
        
        if let uploadedPhoto = post["media"] as? UIImage {
            print("image")
            cell.photoView.image = uploadedPhoto
        } else {
            print("image bad")
        }
    
        // cell.instagramPost = post
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailViewController" {
            let cell = sender as! PhotoCell
            let indexPath = photosTableView.indexPathForCell(cell)
            let postPhoto = posts[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.postPhoto = postPhoto
        }
    }
}
