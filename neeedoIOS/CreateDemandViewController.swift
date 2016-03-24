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

class CreateDemandViewController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate {
    
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
    var chosenlocation = CLLocationCoordinate2D()

    var radius:Float32 = 0.0
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
   
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        
        self.initUser()
    
        chooseLocationBtn.enabled = false
        
        radius = radiusSlider.value
        sliderValue.text = "\(radius)"

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        self.mustHaves.delegate = self
        self.shouldHaves.delegate = self
        self.minPrice.delegate = self
        self.maxPrice.delegate = self
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)

        
    }
    
    // get user loaction
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        self.myUser.userLocation = userLocation.coordinate
        
    }
    
    override func viewWillAppear(animated: Bool) {

        navigationController?.navigationBarHidden = true

    }
    
    // create user element
    func initUser(){
        
        self.myUser.userEmail = NSUserDefaults.standardUserDefaults().stringForKey("UserEmail")!
        self.myUser.userPassword = NSUserDefaults.standardUserDefaults().stringForKey("UserPassword")!
        
        print(self.myUser.userLocation)
        
        if let id = NSUserDefaults.standardUserDefaults().stringForKey("UserID"){
            
            self.myUser.userID = id
        }
    }
    
    // create a new demand
    func createDemand(){
        
        var coordinate = CLLocationCoordinate2D()

        if useCurrentLocationSwitch.on {
            
            coordinate = myUser.userLocation
            
        } else{
            
            coordinate = chosenlocation
        }
        
        if let priceMin = Float32(minPrice.text!){
        
            if let priceMax = Float32(maxPrice.text!){
                
                if let shouldHavesString = shouldHaves.text {
                    
                    let shouldTags = shouldHavesString.componentsSeparatedByString(",")
                    
                    if let mustHavesString = mustHaves.text{
                        
                        let mustTags = mustHavesString.componentsSeparatedByString(",")
                
                        let newDemand = Demand(user: myUser, mustTags: mustTags, shouldTags: shouldTags, location: coordinate, distance: radius, minPrice: priceMin, maxPrice: priceMax)
                    
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
            
            if identifier == "chooseLocationDemand"{
            
                if let clvc =  segue.destinationViewController as? chooseLocationViewController{

                    clvc.identifier = identifier
                    clvc.location = self.myUser.userLocation
                }
            }
        }
    }
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) ->Bool{
        
        textField.resignFirstResponder()
        
        return true
    }

    
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
        sliderValue.text = "\(radius) km"
    
    }
    @IBAction func chooseLocation(sender: AnyObject) {
        
        self.performSegueWithIdentifier("chooseLocationDemand", sender: self)

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}