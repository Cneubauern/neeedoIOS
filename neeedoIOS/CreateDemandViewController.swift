//
//  CreateDemandViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 23.02.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import CoreLocation


class CreateDemandViewController: UIViewController, CLLocationManagerDelegate {
    
    var userId:String = ""
    
    var lat:CLLocationDegrees = 0.0
    var lon:CLLocationDegrees = 0.0
    
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
        
        print(lat, lon)
        
    }

    
    
    func createDemand(){
        
        
        
        
        let location = [
            "lat" :lat ,
            "lon" :lon
        ]
        
        let price = [
            "min":25.0,
            "max":77.0
        ]
        
        let parameters = [
            
            "userID" : userId,
            "mustTags":["socken", "bekleidung", "wolle"],
            "shouldTags":["rot", "weich", "warm"],
            "location": location,
            "distance":30,
            "price": price
            
       
        ]

        
        print("\(userId),\(lat),\(lon)")
        
        print(parameters)

        
    }
    @IBAction func createDemandButtonClicked(sender: AnyObject) {
   
        createDemand()
    }
        
}