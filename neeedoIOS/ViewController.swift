//
//  ViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 04.01.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class ViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var pass: UITextField!
    @IBOutlet var fieldThree: UITextField!
    @IBOutlet var fieldFour: UITextField!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var questionText: UILabel!
    
    var signUpActive = true
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let staticUrl = "https://www.neeedoapi.cneubauern.de"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nil
        username.placeholder = "Your Name"
        pass.placeholder = "Email"
        pass.secureTextEntry = false
        fieldFour.placeholder = "Password"
        fieldThree.placeholder = "Password"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logIn(sender: AnyObject) {
        
        if signUpActive == true{
            
            username.placeholder = "Email"
            pass.placeholder = "Password"
            pass.secureTextEntry = true
            
            fieldFour.hidden = true
            fieldThree.hidden = true
            
            button1.setTitle("Log In", forState: UIControlState.Normal)
           
            questionText.text = "Not yet registered?"
            
            button2.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signUpActive = false
       
        } else{
            
            username.placeholder = "Your Name"
            pass.placeholder = "Email"
            pass.secureTextEntry = false
            fieldFour.placeholder = "Password"
            fieldThree.placeholder = "Password"
            
            button2.setTitle("Log In", forState: UIControlState.Normal)
            
            questionText.text = "Already registered"
            
            button1.setTitle("Sign Up", forState: UIControlState.Normal)

            
            fieldFour.hidden = false
            fieldThree.hidden = false
            

            signUpActive = true
            
        }
        
    }
    @IBAction func signUp(sender: AnyObject) {
        if signUpActive == true && (username.text == "" || pass.text == "" || fieldThree.text == "" || fieldFour.text == ""){
            
            let alert = UIAlertController(title: "Error in Form", message: "Please fill all fields", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in self.dismissViewControllerAnimated(true
                , completion: nil)}))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if  signUpActive == false && (username.text == "" || pass.text == ""){
            
            let alert = UIAlertController(title: "Error in Form", message: "Please insert a Username and Password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in self.dismissViewControllerAnimated(true
            , completion: nil)}))
         
            self.presentViewController(alert, animated: true, completion: nil)
        
        } else if fieldFour.text != fieldThree.text {
            
            let alert = UIAlertController(title: "Error in Form", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in self.dismissViewControllerAnimated(true
                , completion: nil)}))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else {

            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signUpActive == true {
                
                self.signUpWithUsernameInBackground()
                
            }else{
                
                self.logInWithUsernameInBackground()
                
            }
            
            
        }
    }
    
    
    func logInWithUsernameInBackground(){
        
        let user = username.text!
        let password = pass.text!
        
        Alamofire.request(.GET, "\(staticUrl)/users/mail/\(user)")
            .authenticate(user: user, password: password)
            .responseJSON { response in
                
                if response.result.isSuccess{
                    
                    self.performSegueWithIdentifier("login", sender: self)
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                } else {
                    
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()

                    let alert = UIAlertController(title: "Error", message: "An Error occured. Please Try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in self.dismissViewControllerAnimated(true
                        , completion: nil)}))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                    
                    self.username.text = ""
                    self.pass.text = ""

                }
                
        }
        
    }
    
    
    
   
    func signUpWithUsernameInBackground(){
        
        let name = username.text
        let email = pass.text
        let password = fieldThree.text
        
        let parameters = [
            
            "name":"\(name)",
            "email":"\(email)",
            "password":"\(password)"
            
        ]
        
        Alamofire.request(.POST, "\(staticUrl)/users", parameters: parameters, encoding: .JSON).responseJSON { response in
            
            if response.result.isSuccess{
                
                self.performSegueWithIdentifier("login", sender: self)
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
            } else {
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                let alert = UIAlertController(title: "Error", message: "An Error occured. Please Try again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in self.dismissViewControllerAnimated(true
                    , completion: nil)}))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()

                self.username.text = ""
                self.pass.text = ""
                self.fieldThree.text = ""
                self.fieldFour.text = ""
                
            }
            
        }
        
    }
    
}