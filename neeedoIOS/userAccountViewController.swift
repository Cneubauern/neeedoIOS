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

class userAccoutViewController: UITableViewController {
    
    @IBOutlet var account: UILabel!
    
    var myUser = User()
    
    var list = String()
    
    var names = ["Deine Favoriten", "Deine Angebote", "Deine Gesuche"]
    
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        
        if indexPath.section == 1{
            self.performSegueWithIdentifier("messages", sender: self)
        }
        
        if indexPath.section == 2{
            
            switch indexPath.row{
            
            case 0 :
                self.list = "Favorites"
            case 1 :
                self.list = "Demands"
            case 2 :
                self.list = "Offers"
            default:
                self.list = ""
            }
        
            performSegueWithIdentifier("showList", sender: self)
        }
        if indexPath.section == 3{
            
            self.deleteUserAccount()
        }
        if indexPath.section == 4{
            
            self.logoutUser()
        }
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
            if identifier == "showList"{
                
                if let pevc = segue.destinationViewController as? PersonalElementsViewController{
                    
                    pevc.list = self.list
                    
                }
            }
        }
    }
    
    func deleteUserAccount(){
        
        let alert = UIAlertController(title: "Warning", message: "This can not be undone", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "DELETE ACCOUNT", style: UIAlertActionStyle.Default) {
        
            UIAlertAction in
            
            NSLog("Delete Pressed")
            
            User.deleteUser(self.myUser) { (success) -> Void in
                
                if success == true {
                    
                    self.logoutUser()
                }
            }
        }
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func deleteAccount(sender: AnyObject) {
        
   
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}