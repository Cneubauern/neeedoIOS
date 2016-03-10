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
import CoreLocation

class Demands{
    
    func querySingleDemand(demandID:String){
        
        Alamofire.request(.GET, "\(staticUrl)/demands/\(demandID)").responseJSON{
            
            response in
            
            debugPrint(response)
        }
    }
}

class Demand {
    
    var demandID = String()
    var version = Int()
    var userID = String()
    var userName = String()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var distance = Float32()
    var minPrice = Float32()
    var maxPrice = Float32()
    var mustTags = [String]()
    var shouldTags = [String]()
    
    init(userID: String, mustTags:[String], shouldTags:[String], location: CLLocationCoordinate2D, distance:Float32, minPrice: Float32, maxPrice: Float32){
        self.userID = userID
        self.mustTags = mustTags
        self.shouldTags = shouldTags
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.distance = distance
        self.minPrice = minPrice
        self.maxPrice = maxPrice
    }
    
    func generateParameters()->[String:AnyObject]{
        
        let parameters:[String:AnyObject] = [
            
            "userId": self.userID,
            "mustTags":self.mustTags,
            "shouldTags":self.shouldTags,
            "location":[
                "lat":self.latitude,
                "lon":self.longitude
            ],
            "distance":self.distance,
            "price":[
                "min":self.minPrice,
                "max":self.maxPrice
            ]
        ]
        return parameters
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