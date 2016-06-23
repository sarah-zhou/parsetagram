//
//  DetailViewController.swift
//  parsetagram
//
//  Created by Sarah Zhou on 6/21/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var filledHeartImageView: UIImageView!
    @IBOutlet weak var numLikesImageView: UIImageView!
    @IBOutlet weak var numLikesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func photoLiked(sender: AnyObject) {
        if filledHeartImageView.hidden == true {
            self.likePhoto()
        } else if filledHeartImageView.hidden == false {
            self.unlikePhoto()
        }
    }
    
    var postPhoto : Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = postPhoto.img
        
        let caption = postPhoto.obj!["caption"] as? String
        let timestamp = postPhoto.obj!["createdAt"] as? String
        let user = postPhoto.obj!["author"] as? PFUser
        let numLikes = postPhoto.obj!["likesCount"] as? Int
        
        captionLabel.text = caption
        captionLabel.sizeToFit()
        timestampLabel.text = timestamp
        usernameLabel.text = user!.username
        
        if numLikes > 0 {
            numLikesImageView.hidden = false
            if numLikes == 1 {
                numLikesLabel.text = "\(numLikes!) Like"
            } else {
                numLikesLabel.text = "\(numLikes!) Likes"
            }
        } else {
            numLikesLabel.text = ""
            numLikesImageView.hidden = true
        }
        
        filledHeartImageView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func likePhoto() {
        var likesCount = postPhoto.obj!["likesCount"] as? Int
        likesCount = likesCount! + 1
        
        if likesCount > 0 {
            numLikesImageView.hidden = false
            if likesCount == 1 {
                numLikesLabel.text = "\(likesCount!) Like"
            } else {
                numLikesLabel.text = "\(likesCount!) Likes"
            }
        } else {
            numLikesLabel.text = ""
            numLikesImageView.hidden = true
        }
        filledHeartImageView.hidden = false
        postPhoto.obj!["likesCount"] = likesCount
    }
    
    func unlikePhoto() {
        var likesCount = postPhoto.obj!["likesCount"] as? Int
        likesCount = likesCount! - 1
        
        if likesCount > 0 {
            numLikesImageView.hidden = false
            if likesCount == 1 {
                numLikesLabel.text = "\(likesCount!) Like"
            } else {
                numLikesLabel.text = "\(likesCount!) Likes"
            }
        } else {
            numLikesLabel.text = ""
            numLikesImageView.hidden = true
        }
        filledHeartImageView.hidden = true
        postPhoto.obj!["likesCount"] = likesCount
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
