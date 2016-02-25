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
        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "userName")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "userID")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "userPassword")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "userEmail")
        
        
        self.performSegueWithIdentifier("logout", sender: self)

        
    }
    
    func deleteUserAccount(){
        NSLog("Delete Pressed")
        
        if let id = NSUserDefaults.standardUserDefaults().objectForKey("userID"){
            if let version = NSUserDefaults.standardUserDefaults().objectForKey("userVersion"){
                
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