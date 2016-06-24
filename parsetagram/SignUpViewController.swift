//
//  SignUpViewController.swift
//  
//
//  Created by Sarah Zhou on 6/20/16.
//
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameTakenView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBAction func onSignUp(sender: AnyObject) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser["profilepic"] = NSNull()
        
        // call sign up function on the object
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("Created a user")
                self.usernameTakenView.hidden = true
                self.performSegueWithIdentifier("loggedInSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    print("Username is taken")
                    self.usernameTakenView.hidden = false
                }
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.sendSubviewToBack(backgroundImageView)
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        usernameField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameField.autocorrectionType = .No
        
        usernameTakenView.hidden = true
        
        usernameField.attributedPlaceholder = NSAttributedString(string:"Username",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        signupButton.backgroundColor = UIColor.clearColor()
        signupButton.layer.borderWidth = 1.0
        signupButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        signupButton.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
