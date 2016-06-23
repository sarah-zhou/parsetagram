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

class OtherUserViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var otherCollectionView: UICollectionView!
    @IBOutlet weak var otherFlowLayout: UICollectionViewFlowLayout!
    
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

        // Do any additional setup after loading the view.
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
