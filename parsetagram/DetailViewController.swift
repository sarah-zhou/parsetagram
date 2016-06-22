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
    @IBOutlet weak var numLikesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var postPhoto : Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = postPhoto.img
        
        let caption = postPhoto.obj!["caption"] as? String
        
        if let user = postPhoto.obj!["author"] as? PFUser {
            usernameLabel.text = user.username
        } else {
            usernameLabel.text = "NO USER"
        }
        
        captionLabel.text = caption
        captionLabel.sizeToFit()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
