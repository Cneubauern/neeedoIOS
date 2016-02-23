//
//  CreateOfferViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 23.02.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import CoreLocation

class CreateOfferViewController: UIViewController,  CLLocationManagerDelegate{
   
    var userId:String = ""
    
    var lat = 0.0
    var lon = 0.0
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        if let id = NSUserDefaults.standardUserDefaults().objectForKey("userID"){
            
            userId = "\(id)" as String
            
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        lat = latitude
        lon = longitude
                
    }
    
    
    
    func createDemand(){
        
        let price = 25.0
        
        let parameters = [
            
            "userId": userId,
            
            "tags":["socken", "bekleidung", "wolle"],
            
            "location":[
                "lat": lat,
                "lon": lon
            ],
            "price":price,
            
            "images":[]
        ]
        
        print(parameters)
        
        
        Alamofire.request(.POST, "\(staticUrl)/offers", parameters: (parameters as! [String : AnyObject]), encoding: .JSON).responseJSON{ response in
            
            
            if let JSON = response.result.value {
                print(JSON)
            }
            
        }
        
    }
    
}