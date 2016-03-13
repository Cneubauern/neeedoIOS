//
//  userAccountViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 25.02.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class userAccoutViewController: UIViewController {
    
    @IBOutlet var account: UILabel!
    
    var myUser = User()
    
    override func viewDidLoad() {
        
        myUser.userID = NSUserDefaults.standardUserDefaults().stringForKey("UserID")!
        myUser.userVersion = NSUserDefaults.standardUserDefaults().integerForKey("UserVersion")
        
        account.text = NSUserDefaults.standardUserDefaults().stringForKey("UserName")
        
    }
    
    func logoutUser(){
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("UserName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("UserID")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("UserPassword")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("UserEmail")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("UserVersion")
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "UserLoggedIn")
        
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
        if let identifier = segue.identifier{
            
            print(identifier)
            
            if identifier == "logout"{
                
                print("going to logout")
                
                if let vc =  segue.destinationViewController as? ViewController{
                    
                    print("I am loggingout")
                    vc.signUpActive = true
                }
            }
        }
    }
    
    func deleteUserAccount(){
        
        NSLog("Delete Pressed")
        
        User.deleteUser(myUser) { (success) -> Void in
            
            if success == true {
                
                self.logoutUser()
            }
        }
    }
    
    @IBAction func deleteAccount(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Warning", message: "This can not be undone", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "DELETE ACCOUNT", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.deleteUserAccount()
        }
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
        self.logoutUser()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}