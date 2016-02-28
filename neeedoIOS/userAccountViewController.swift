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
    override func viewDidLoad() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func logoutUser(){
        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "UserName")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "UserID")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "UserPassword")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "UserEmail")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "UserVersion")
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "UserLoggedIn")
        
        signUpActive = true
        
        self.performSegueWithIdentifier("logout", sender: self)
        

        
    }
    
    func deleteUserAccount(){
        NSLog("Delete Pressed")
        
        if let id = NSUserDefaults.standardUserDefaults().objectForKey("UserID"){
            if let version = NSUserDefaults.standardUserDefaults().objectForKey("UserVersion"){
                
                Alamofire.request(.DELETE, "\(staticUrl)/users/\(id)/\(version)").response { response in
                    debugPrint(response)
                }
                
            }
        }
        
        logoutUser()

    }
    
    @IBAction func deleteAccoutn(sender: AnyObject) {
        
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
}