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
    
    var demand:Demands = Demands()
    
    override func viewDidLoad() {
        //
            
        self.getMatchingOffers()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMatchingOffers(){
        
        
        
    }
}

