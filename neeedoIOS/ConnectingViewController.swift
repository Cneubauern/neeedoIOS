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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func finishedLogInAndLoading(){
        
    }
    
}
