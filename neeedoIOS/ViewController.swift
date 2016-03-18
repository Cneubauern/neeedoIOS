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

let staticUrl = "https://www.neeedoapi.cneubauern.de"

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passControl: UITextField!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var questionText: UILabel!
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var titleLabel: UILabel!
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var signUpActive = true

    var myUser:User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController")

        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.passControl.delegate = self
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)

    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Check if User is already logged in
        
        print("Funktion: ViewController.viewDidAppear")

        if NSUserDefaults.standardUserDefaults().boolForKey("UserLoggedIn"){
            
            signUpActive = false
                    
            self.performSegueWithIdentifier("logIn", sender: self)
        }
    }
  
    @IBAction func logIn(sender: AnyObject) {
        
        // change Views according to state
        
        print("Funktion: logIn")
        
        if signUpActive == true{
            
            username.hidden = true
        
            passControl.hidden = true
        
            button1.setTitle("Log In", forState: UIControlState.Normal)
            
            titleLabel.text = "Benutzte das Formular um dich zu einzuloggen"
            questionText.text = "Noch nicht registriert?"
            questionLabel.text = "Dann registriere dich hier"
            
            button2.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signUpActive = false
            
        } else{
            
            button2.setTitle("Log In", forState: UIControlState.Normal)
            
            titleLabel.text = "Benutzte das Formular um dich zu registrieren"
            questionText.text = "Bist du bereits registriert?"
            questionLabel.text = "Dann Logge dich hier ein"

            button1.setTitle("Sign Up", forState: UIControlState.Normal)
            
            username.hidden = false
            
            passControl.hidden = false
            
            signUpActive = true
        }
        
        print("SignUpActive: \(signUpActive)")

    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        print("Funktion: signUp")
        print("SignUpActive: \(signUpActive)")
        
        //check if usernames and passwords are acceptable
        
        self.makeUser()
        
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
                
                self.loginWithUsername()
            }
        }
    }
    
    func makeUser(){
        
        //create user element
    
        let userName = username.text! as String
        let eMail = email.text! as String
        let passWord = password.text! as String

        myUser.userName = userName
        myUser.userEmail = eMail
        myUser.userPassword = passWord
    }
    
    func loginWithUsername(){
        
        myUser.checkUser { (user, success) -> Void in
            
            if success == true{
                
                if let name = user!["name"] as? String{
                    
                    self.myUser.userName = name
                }
                if let id = user!["id"] as? String{
                    
                    self.myUser.userID = id
                    
                }
                
                if let version = user!["version"] as? Int{
                    self.myUser.userVersion = version
                }
                
                self.fillUserDefaults()
                
                self.performSegueWithIdentifier("logIn", sender: self)
                
            } else {
                
                self.errorAlert("Du konntest nicht ein geloggt werden, bitte versuche es erneut")
            }
        }
    }

    func signUpWithUsername(){
        
        print("Funktion: signUpWithUsername")
        
        User.createUser(myUser) { (user, success) -> Void in
            
            if success == true{
                
                if let id = user!["id"] as? String{
                    
                    self.myUser.userID = id
                    
                }
                
                if let version = user!["version"] as? Int{
                    self.myUser.userVersion = version
                }
                
                self.fillUserDefaults()
                
                self.performSegueWithIdentifier("logIn", sender: self)
                
            } else {
                
                self.myUser.checkUser({ ( user , success) -> Void in
                    
                    if success == true{
                        
                        self.errorAlert("Du bist bereits registriert, Bitte logge dich ein")
                   
                    } else {
                        
                        self.errorAlert("Es ist ein Fehler aufgetreten, bitte versuche es erneut")
                    }
                })
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if let identifier = segue.identifier{
            
            print("Seque:", identifier)
            
            if identifier == "logIn"{
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UserLoggedIn")
                
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
    
    func fillUserDefaults(){
        
        print("Funktion: fillUserDefaults")
        
        NSUserDefaults.standardUserDefaults().setObject(myUser.userName, forKey: "UserName")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userEmail, forKey: "UserEmail")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userPassword, forKey: "UserPassword")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userID, forKey: "UserID")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userVersion, forKey: "UserVersion")
        
    }
    
    func errorAlert(text: String){
        
        print("loginError")
        
        let alert = UIAlertController(title: "Entschuldigung", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        

        let goBack = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(goBack)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}