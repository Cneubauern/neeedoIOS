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
        
        //print(lat, lon)
        
    }

    
    
    func createDemand(){
        
        
        let distance = 30.0
       // let minPrice = 25.0
       // let maxPrice = 77.0
        
        let tag1 = "socken"
        let tag2 = "bekleidung"
        
        let parameters = [
            
            "userId" : userId,
            "mustTags":[tag1, tag2],
            "shouldTags":[tag1, tag2],
            "location": [
                "lat" :lat ,
                "lon" :lon
            ]
,
            "distance": distance ,
            "price": [
                "min": 25.0,
                "max": 77.0
            ]
        ]
        
        print(parameters)

        
        Alamofire.request(.POST, "\(staticUrl)/demands", parameters: parameters as! [String : AnyObject], encoding: .JSON).responseJSON{ response in
         
            
            if let JSON = response.result.value {
                print(JSON)
            }
            
        }
        
    }
    @IBAction func createDemandButtonClicked(sender: AnyObject) {
   
        createDemand()
    }
        
}