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
    
    var username:String = String()
    var email:String = String()
    var password:String = String()
    var userId:String = String()
    var version:Int = Int()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    var signUpActive = Bool()
    var myUser:User = User()

    
    override func viewDidLoad() {
       
        print("Funktion: ConnectingViewController.ViewDidLoad")
        
        username = myUser.userName
        email  = myUser.userEmail
        password = myUser.userPassword
        userId = myUser.userID
        version = myUser.userVersion
        
        print("Variables:",username, email, password, userId, version)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            loginUser()
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    func loginUser(){
        
        print("Funktion: loginUser")
        
        if signUpActive {
            
            print("SignUpActive:", signUpActive)
            
            User.createUser(myUser,completionhandler:{ success in
                
                if success == true{
                    
                    self.userLoggedIn()
                    
                } else {
                    
                    self.errorAlert()
                }
            })
            
        } else{
            
            print("SignUpActive:", signUpActive)
            
            myUser.checkUser(){ success in
                
                if success == true {
                    
                    self.userLoggedIn()
                    
                } else {
                    
                    self.errorAlert()
                }
            }
        }
        
    }
    
    
    func fillUserDefaults(){
        
        print("Funktion: fillUserDefaults")
        
        myUser.completeUser(){ name, id, version in
            
            self.myUser.userID = id!
            self.myUser.userVersion = version!
        }
        
        NSUserDefaults.standardUserDefaults().setObject(myUser.userName, forKey: "UserName")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userEmail, forKey: "UserEmail")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userPassword, forKey: "UserPassword")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userID, forKey: "UserID")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userVersion, forKey: "UserVersion")

    }
    
    
    func userLoggedIn(){
        
        print("Funktion: userLoggedIn")
    
        if signUpActive{
            
            finishedLogInAndLoading()
            
        }else{
            
            finishedLogInAndLoading()
           // self.loadUserData()
        }
        
    }
    
    func errorAlert(){
        
        print("loginError")
        
        let alert = UIAlertController(title: "Sorry", message:  "An Error occured while Logging You in ", preferredStyle: UIAlertControllerStyle.Alert)
        
        let goBack = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("loginError", sender: self)
        }
        
        alert.addAction(goBack)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    
    func finishedLogInAndLoading(){
        activityIndicator.stopAnimating()
        self.performSegueWithIdentifier("loggedIn", sender: self)
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier{
            
            print("Seque:", identifier)
            
            if identifier == "login"{
                
                self.fillUserDefaults()

                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UserLoggedIn")
            }
        }
    }
}
