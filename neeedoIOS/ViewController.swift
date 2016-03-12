//
//  ViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 04.01.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import UIKit
import Foundation
import Alamofire




class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passControl: UITextField!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var questionText: UILabel!
    
    var signUpActive = true

    var newUser:User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nil
        
        print("Funktion: ViewController.viewDidLoad")

        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.passControl.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("Funktion: ViewController.viewDidAppear")

        
        if NSUserDefaults.standardUserDefaults().boolForKey("UserLoggedIn"){
            
            signUpActive = false
                    
            self.performSegueWithIdentifier("userLoggedIn", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func logIn(sender: AnyObject) {
        
        print("Funktion: logIn")
        
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
        
        print("Funktion: signUp")
        print("SignUpActive: \(signUpActive)")
        
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
                
                self.signUpWithUsername()
            }
        
        }  else if !signUpActive{
            
            if email.text == "" || password.text == ""{
                
                let alert = UIAlertController(title: "Error in Form", message: "Please insert a Username and Password", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in self.dismissViewControllerAnimated(true
                    , completion: nil)}))
                
                self.presentViewController(alert, animated: true, completion: nil)

            } else {
                
                self.signUpWithUsername()
            }
        }
    }
    
    
    func signUpWithUsername(){
        
        print("Funktion: signUpWithUsername")
        
        let userName = username.text! as String
        let eMail = email.text! as String
        let passWord = password.text! as String
        
        newUser.userName = userName
        newUser.userEmail = eMail
        newUser.userPassword = passWord
        
        newUser.completeUser(){ name, id, version in
            
            self.newUser.userName = name!
            self.newUser.userID = id!
            self.newUser.userVersion = version!
            
        }

        self.performSegueWithIdentifier("login", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if let identifier = segue.identifier{
            
            print("Seque:", identifier)
            
            if identifier == "login"{
                
                print("going to login")
                
                if let loginViewController =  segue.destinationViewController as? ConnectingViewController{
                    
                    print("I am loggingIn")
                    loginViewController.myUser = self.newUser
                    loginViewController.signUpActive = self.signUpActive
                }
            }
            if identifier == "userLoggedIn"{
                
                
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) ->Bool{
        
        textField.resignFirstResponder()
        
        return true
    }

}