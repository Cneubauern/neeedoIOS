//
//  DemandsViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 10.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class Demands: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func querySingleDemand(demandID:String){
        
        Alamofire.request(.GET, "\(staticUrl)/demands/\(demandID)").responseJSON{
            
            response in
            
            debugPrint(response)
        }
        
    }

    func updateDemand(demandID:String, version: Int, parameters: [String : AnyObject]){
        
        Alamofire.request(.PUT, "\(staticUrl)/demands/\(demandID)/\(version)", parameters: parameters, encoding: .JSON).responseJSON{
            response in
            
            debugPrint(response)
        }
        
    }

    func deleteDemand(demandID:String, version: Int){
        
        Alamofire.request(.DELETE, "\(staticUrl)/\(demandID)/\(version)").responseJSON{
            response in
            
            debugPrint(response)
        }
    }
    

}