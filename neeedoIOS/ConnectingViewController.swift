//
//  ConnectingViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 27.02.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let staticUrl = "https://www.neeedoapi.cneubauern.de"

class ConnectingViewController: UIViewController {
    
    var username = String()
    var email = String()
    var password = String()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()


    
    override func viewDidLoad() {
        print("Connecting")
        
        if  let user = NSUserDefaults.standardUserDefaults().objectForKey("UserName") {
            username = user as! String
        }
        if  let mail = NSUserDefaults.standardUserDefaults().objectForKey("UserEmail") {
                email  = mail as! String
        }
        if let  pass = NSUserDefaults.standardUserDefaults().objectForKey("UserPassword"){
            password = pass as! String
            
        }

        print(username, email, password)
        
        loginUser()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loginUser(){
        
        if signUpActive {
            
           signUpWithUsername()

        
        } else{
            LogInWithUsername()
        }
        
    }
    
    func userLoggedIn(){
        
            print("Login Success")
            NSUserDefaults.standardUserDefaults().setObject("loggedIn", forKey: "UserLoggedIn")
        
            self.loadUserData()
        
    }
    
    func signUpWithUsername(){
        
        print("signUp")
        
        let parameters = [
            
            "name":"\(username)",
            "email":"\(email)",
            "password":"\(password)"
            
        ]
        
        Alamofire.request(.POST, "\(staticUrl)/users", parameters: parameters, encoding: .JSON).responseJSON { response in
            
            if response.result.isSuccess{
                
                if let JSON = response.result.value {
                    
                    print("\(JSON)")
                    
                    if let user = JSON["user"] as? NSDictionary{
                        
                        print("\(user)")
                        
                        if let id = user["id"]{
                            
                            NSUserDefaults.standardUserDefaults().setObject("\(id)", forKey: "UserID")
                        
                        
                    }
                        if let version = user["version"]{
                            
                            NSUserDefaults.standardUserDefaults().setObject("\(version)", forKey: "userVersion")
                            
                        }

                    
                }
                
                    self.userLoggedIn()
                
            } else {
                    
                    self.errorAlert()
                
            }
            
        }
        
    }
    }
    
    func LogInWithUsername(){
        
        print("logIn")
        
        
        let user = email
        let pass = password
        
        print(email , pass)
        
        Alamofire.request(.GET, "\(staticUrl)/users/mail/\(email)").authenticate(user: user, password: pass).responseJSON{response in

            if response.result.isSuccess{
                if let JSON = response.result.value {
                
                    print("\(JSON)")
                    
                    if let user = JSON["user"] as? NSDictionary{
                        
                        print("\(user)")
                        
                        if let id = user["id"]{
                            
                            NSUserDefaults.standardUserDefaults().setObject("\(id)", forKey: "UserID")
                            
                            
                        }
                        if let version = user["version"]{
                            
                            NSUserDefaults.standardUserDefaults().setObject("\(version)", forKey: "userVersion")
                            
                        }
                        
                    }
                }

                self.userLoggedIn()
                
            } else {
                self.errorAlert()
            }
        }
    }

    func errorAlert(){
        
        let alert = UIAlertController(title: "Sorry", message:  "An Error occured while Logging You in ", preferredStyle: UIAlertControllerStyle.Alert)
        
        let goBack = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("loginError", sender: self)
        }
        
        alert.addAction(goBack)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    


    func loadUserData(){
        print("We will load the Data now")
    }
}
