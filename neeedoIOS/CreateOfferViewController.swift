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

class CreateOfferViewController: UIViewController,  CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    var userId:String = ""
    
    var lat = 0.0
    var lon = 0.0
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var currentLocationSwitch: UISwitch!
    @IBOutlet var chooseLocationBtn: UIButton!
    
    
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
    
    @IBAction func createOfferBtnClicked(sender: AnyObject) {
        createOffer()
    }
    
    
    func createOffer(){
        
        if let price = Double(priceTextField.text!){
            
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
            
        } else{
            
            
            
            print("Missing Elements")
        }
        
    }
    
    @IBAction func addImages(sender: AnyObject) {
    }
    @IBAction func chooseLocation(sender: AnyObject) {
        
        self.performSegueWithIdentifier("chooseLocation", sender: self)
        
    }
    @IBAction func useCurrentLocation(sender: AnyObject) {
        
        if currentLocationSwitch.on {
            
            chooseLocationBtn.enabled = false
            
        } else {
            chooseLocationBtn.enabled = true
        }
        
    }
    @IBAction func openScanner(sender: AnyObject) {
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        let image = UIImagePickerController()
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)

        
    }
    @IBAction func chooseImage(sender: AnyObject) {
        
        let image = UIImagePickerController()
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Image Selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}