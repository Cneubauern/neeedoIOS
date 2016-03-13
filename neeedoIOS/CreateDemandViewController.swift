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
    
    
    var myUser = User()

    var myNewDemand = Demands()
    
    var location = CLLocationCoordinate2D()
    
    
    var userId:String = ""
    
    var radius:Float32 = 0.0
    
    var locationManager = CLLocationManager()
    
    var demandParameters = NSDictionary()
    
    override func viewDidLoad() {
        
        self.initUser()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        chooseLocationBtn.enabled = false
        
        radius = radiusSlider.value
        sliderValue.text = "\(radius)"

    }
    
    func initUser(){
        
        self.myUser.userEmail = NSUserDefaults.standardUserDefaults().stringForKey("UserEmail")!
        self.myUser.userPassword = NSUserDefaults.standardUserDefaults().stringForKey("UserPassword")!
        
        if let id = NSUserDefaults.standardUserDefaults().stringForKey("UserID"){
            
            userId = id
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        location = userLocation.coordinate
        }

    
    func createDemand(){
        
        if let priceMin = Float32(minPrice.text!){
        
            if let priceMax = Float32(maxPrice.text!){
                
                if let shouldHavesString = shouldHaves.text {
                    
                    let shouldTags = shouldHavesString.componentsSeparatedByString(",")
                    
                    if let mustHavesString = mustHaves.text{
                        
                        let mustTags = mustHavesString.componentsSeparatedByString(",")
                
                        let newDemand = Demand(user: myUser, mustTags: mustTags, shouldTags: shouldTags, location: location, distance: radius, minPrice: priceMin, maxPrice: priceMax)
                    
                        Demands.createDemand(myUser, demand: newDemand, completionhandler: { (success) -> Void in
                            
                            if success == true {
                                
                                self.myNewDemand = newDemand as Demands
                                
                                self.performSegueWithIdentifier("matching", sender: self)
                                
                            }
                        })
                    }
                }
            }
        } else {
            
            print("Missing Elements")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("preparing for segue")
        
        if let identifier = segue.identifier{
           
            print(identifier)

            if identifier == "matching"{
                
                print("going to match")
               
                if let matchingViewController =  segue.destinationViewController as? MatchingViewController{
                    
                    print("I am matching")
                    matchingViewController.demand = self.myNewDemand
                    
                }
            }
        }
    }
    
    
/*    func saveNewDemand(minPrice:Double, maxPrice:Double, mustTags:[String], shouldTags:[String], distance:Float32){
        
        var newDemand = NSEntityDescription.insertNewObjectForEntityForName("Demands", inManagedObjectContext: context)
        
        let saveShouldTags = shouldTags.joinWithSeparator(",")
        let saveMustTags = mustTags.joinWithSeparator(",")
        
        newDemand.setValue(userId, forKey: "id")
        newDemand.setValue(saveMustTags, forKey: "mustTags")
        newDemand.setValue(saveShouldTags, forKey: "shouldTags")
        newDemand.setValue(location.latitude, forKey: "lat")
        newDemand.setValue(location.longitude, forKey: "lon")
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
    */
    
    @IBAction func createDemandButtonClicked(sender: AnyObject) {
        
        if shouldHaves.text != "" && mustHaves.text != "" && minPrice != "" && maxPrice != "" {
            
            self.createDemand()
            
        } else {
            let alert = UIAlertController(title: "Missing Data", message: "Please fill in all Values", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action)-> Void in alert.dismissViewControllerAnimated(true, completion: nil)}))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
   
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}