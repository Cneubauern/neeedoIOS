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
import CoreData

class MatchingViewController: UIViewController {
    
    var demandParameters = NSDictionary()
    
    override func viewDidLoad() {
        //
    
        print(demandParameters)
        
        self.getMatchingOffers()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMatchingOffers(){
        
        
        let user = NSUserDefaults.standardUserDefaults().stringForKey("UserEmail")
        let pass = NSUserDefaults.standardUserDefaults().stringForKey("UserPassword")
        
        Alamofire.request(.POST, "\(staticUrl)/matching/demand", parameters: demandParameters as? [String : AnyObject], encoding: .JSON).responseJSON{ response in
            
            debugPrint(response)
    }
    
    }
}

