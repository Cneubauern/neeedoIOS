//
//  ViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 04.01.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import UIKit
import Foundation

var signUpActive = true


class ViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passControl: UITextField!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var questionText: UILabel!
    
    
    override func viewDidLoad() {
       // super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nil
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("UserLoggedIn"){
            
            print(NSUserDefaults.standardUserDefaults().stringForKey("UserName")!)
            print(NSUserDefaults.standardUserDefaults().stringForKey("UserEmail")!)
            print(NSUserDefaults.standardUserDefaults().stringForKey("UserPassword")!)
            
            signUpActive = false
            
            self.performSegueWithIdentifier("userLoggedIn", sender: self)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func logIn(sender: AnyObject) {
        
        if signUpActive == true{
            
            username.hidden = true
            passControl.hidden = true
            
            button1.setTitle("Log In", forState: UIControlState.Normal)
            
            questionText.text = "Not yet registered?"
            
            button2.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signUpActive = false
            
        } else{
            
            
            
            button2.setTitle("Log In", forState: UIControlState.Normal)
            
            questionText.text = "Already registered"
            
            button1.setTitle("Sign Up", forState: UIControlState.Normal)
            
            
            username.hidden = false
            passControl.hidden = false
            
            signUpActive = true
            
        }
    }
    @IBAction func signUp(sender: AnyObject) {
        
        
        print("\(signUpActive)")
        
        if signUpActive{
            
            if username.text == "" || email.text == "" || password.text == "" || passControl.text == "" {
                
                let alert = UIAlertController(title: "Error in Form", message: "Please fill all fields", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in self.dismissViewControllerAnimated(true
                    , completion: nil)}))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            if passControl.text != password.text {
                
                let alert = UIAlertController(title: "Error in Form", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in self.dismissViewControllerAnimated(true
                    , completion: nil)}))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                self.signUpWithUsernameInBackground()
            }
        
        }  else if !signUpActive{
            
            if email.text == "" || password.text == ""{
                
                let alert = UIAlertController(title: "Error in Form", message: "Please insert a Username and Password", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in self.dismissViewControllerAnimated(true
                    , completion: nil)}))
                
                self.presentViewController(alert, animated: true, completion: nil)

            
            } else {
                self.signUpWithUsernameInBackground()
            }
        }
    }
    
    
    func signUpWithUsernameInBackground(){
        
        print("loggingIn")
        
        let userName = username.text! as String
        let eMail = email.text! as String
        let passWord = password.text! as String
        
        
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "UserName")
        NSUserDefaults.standardUserDefaults().setObject(eMail, forKey: "UserEmail")
        NSUserDefaults.standardUserDefaults().setObject(passWord, forKey: "UserPassword")
        
        
        self.performSegueWithIdentifier("login", sender: self)
    }

}