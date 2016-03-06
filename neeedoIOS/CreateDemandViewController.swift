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
import CoreData 

class CreateDemandViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mustHaves: UITextField!
    
    @IBOutlet var shouldHaves: UITextField!
    
    @IBOutlet var minPrice: UITextField!
    
    @IBOutlet var maxPrice: UITextField!
    
    @IBOutlet var useCurrentLocationSwitch: UISwitch!
    
    @IBOutlet var chooseLocationBtn: UIButton!
    
    @IBOutlet var radiusSlider: UISlider!
    
    @IBOutlet var sliderValue: UILabel!
    
    var userId:String = ""
    
    var lat = 0.0
    var lon = 0.0
    var radius:Float32 = 0.0
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        if let id = NSUserDefaults.standardUserDefaults().stringForKey("UserID"){
            
            userId = id
        
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        chooseLocationBtn.enabled = false
        
        radius = radiusSlider.value
        sliderValue.text = "\(radius)"

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
        
        

        
        let distance = radius
        if let priceMin = Double(minPrice.text!){
            if let priceMax = Double(maxPrice.text!){
                
                let shouldTags = ["socken", "bekleidung"]

                let mustTags = ["socken", "bekleidung"]
                
                let parameters = [
                    
                    "userId" : userId,
                    "mustTags":mustTags,
                    "shouldTags":shouldTags,
                    "location": [
                        "lat" :lat ,
                        "lon" :lon
                    ]
                    ,
                    "distance": distance ,
                    "price": [
                        "min": priceMin,
                        "max": priceMax
                    ]
                ]
                
                print(parameters)
                
                self.saveNewDemand(priceMin, maxPrice: priceMax, mustTags: mustTags, shouldTags: shouldTags, distance: distance)
                
                Alamofire.request(.POST, "\(staticUrl)/demands", parameters: (parameters as! [String : AnyObject]), encoding: .JSON).responseJSON{ response in
                    
                    
                    if let JSON = response.result.value {
                        print(JSON)
                    }
                    
                }
                
            }

        } else{
            print("Missing Elements")
        }
        
        
    }
    
    func saveNewDemand(minPrice:Double, maxPrice:Double, mustTags:[String], shouldTags:[String], distance:Float32){
        
        var newDemand = NSEntityDescription.insertNewObjectForEntityForName("Demands", inManagedObjectContext: context)
        
        let saveShouldTags = shouldTags.joinWithSeparator(",")
        let saveMustTags = mustTags.joinWithSeparator(",")
        
        newDemand.setValue(userId, forKey: "id")
        newDemand.setValue(saveMustTags, forKey: "mustTags")
        newDemand.setValue(saveShouldTags, forKey: "shouldTags")
        newDemand.setValue(lat, forKey: "lat")
        newDemand.setValue(lon, forKey: "lon")
        newDemand.setValue(distance, forKey: "distance")
        newDemand.setValue(minPrice , forKey: "price")
        newDemand.setValue(maxPrice , forKey: "price")
        
        do{
            try context.save()
        }catch{
            print("Error Saving offer")
        }
        
        let requestDemands = NSFetchRequest(entityName: "Demands")
        
        requestDemands.returnsObjectsAsFaults = false
        
        do{
            let search = try context.executeFetchRequest(requestDemands)
            
            print(search)
            
        } catch {
            
            
        }
        
    }
    
    
    @IBAction func createDemandButtonClicked(sender: AnyObject) {
   
        createDemand()
    }
        
    @IBAction func useCurrentLocationSwitched(sender: AnyObject) {
        
        if useCurrentLocationSwitch.on {
            chooseLocationBtn.enabled = false
        }else {
            chooseLocationBtn.enabled = true
        }
        
    }
    @IBAction func valueChanged(sender: AnyObject) {
        radius = radiusSlider.value
        sliderValue.text = "\(radius)"
    }
    @IBAction func chooseLocation(sender: AnyObject) {
        
        self.performSegueWithIdentifier("chooseLocation", sender: self)

    }
    
}