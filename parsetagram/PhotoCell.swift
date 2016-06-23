//
//  PhotoCell.swift
//  parsetagram
//
//  Created by Sarah Zhou on 6/20/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotoCell: UITableViewCell {
    
    // @IBOutlet weak var doubleTapIcon: UIImageView!
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        
        /* let gesture = UITapGestureRecognizer(target: self, action:#selector(PhotoCell.onDoubleTap(_:)))
        gesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(gesture)
        
        doubleTapIcon?.hidden = true */
        
        super.awakeFromNib()
    }
    
    /*
    func onDoubleTap(sender:AnyObject) {
        doubleTapIcon?.hidden = false
        doubleTapIcon?.alpha = 1.0
        
        UIView.animateWithDuration(0.6, delay: 0.3, options: [], animations: {
            
            self.doubleTapIcon?.alpha = 0
            
            }, completion: {
                (value:Bool) in
                
                self.doubleTapIcon?.hidden = true
        })
    } */

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
