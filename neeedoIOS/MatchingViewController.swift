//
//  MatchingViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 07.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MatchingViewController: UIViewController {
    
    var demand:Demands = Demands()
    
    var myUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUser()
            
        self.getMatchingOffers()
        
    }
    
    func initUser(){
        
        self.myUser.userEmail = NSUserDefaults.standardUserDefaults().stringForKey("UserEmail")!
        self.myUser.userPassword = NSUserDefaults.standardUserDefaults().stringForKey("UserPassword")!
        
        if let id = NSUserDefaults.standardUserDefaults().stringForKey("UserID"){
            
            self.myUser.userID = id
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMatchingOffers(){
        
        Demands.demandGetMatchingOffers(myUser, demand: demand as! Demand) { (demands) -> Void in
           
            for match in demands! {
                
                print(match)
                
            }
        }
        
    }
}

