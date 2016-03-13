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
import CoreData 

class CreateOfferViewController: UIViewController,  CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    var myUser:User = User()
    var myNewOffer = Offers()
    
    var location = CLLocationCoordinate2D()
    
    var imageURL = NSURL()
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var currentLocationSwitch: UISwitch!
    @IBOutlet var chooseLocationBtn: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    
    var locationManager = CLLocationManager()
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        
        self.initUser()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        chooseLocationBtn.enabled = false
        
        imagePicker.delegate = self

        
    }
    
    func initUser(){
        
        self.myUser.userEmail = NSUserDefaults.standardUserDefaults().stringForKey("UserEmail")!
        self.myUser.userPassword = NSUserDefaults.standardUserDefaults().stringForKey("UserPassword")!
        
        if let id = NSUserDefaults.standardUserDefaults().stringForKey("UserID"){
            
            self.myUser.userID = id
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        location = userLocation.coordinate
        
    }
    
    func createOffer(){
        
        if let price = Float32(priceTextField.text!){
            
            if let tagsString = descriptionTextField.text {
                
                let tags = tagsString.componentsSeparatedByString(",")
                
                
                Offers.createOffer(myUser, offer: Offer(userID: myUser.userID, tags: tags, location: self.location, price: price, images: []), completionhandler: { (success) -> Void in
                   
                    if success == true {
                        print("created")
                    }
                })
            }
        }else{
            
            print("Missing Elements")
        
        }
    }

        
/*    func saveNewOffer(price:Double, tags:[String]){
        
        var newOffer = NSEntityDescription.insertNewObjectForEntityForName("Offers", inManagedObjectContext: context)

        let saveTags = tags.joinWithSeparator(",")
        
        print(saveTags)
        
        newOffer.setValue(userId, forKey: "id")
        newOffer.setValue(saveTags, forKey: "tags")
        newOffer.setValue(lat, forKey: "lat")
        newOffer.setValue(lon, forKey: "lon")
        newOffer.setValue(price , forKey: "price")
        
        do{
            try context.save()
        }catch{
            print("Error Saving offer")
        }
        
        let requestOffers = NSFetchRequest(entityName: "Offers")
        
        requestOffers.returnsObjectsAsFaults = false
        
        do{
            let search = try context.executeFetchRequest(requestOffers)
        
                print(search)
            
        } catch {
            
            
        }

    }*/

    
    //This function is called everytime the user is done picking or taking images
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
       
        print("Image Selected")
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        if let pickedImageURL = info[UIImagePickerControllerReferenceURL] as? NSURL{
            
            if let pickedImageName = pickedImageURL.lastPathComponent{
                
                print(pickedImageURL.path)

                print(pickedImageName)
                
                imageURL = pickedImageURL
                
            }
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //This funtion sends the image to the needo API and makes sure they can be accessed in the createOffer - Method
    func uploadImage(image:[UIImage]){
            
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
    
    // Opens the Camera and allows the User to take a Photo
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        let image = UIImagePickerController()
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    //Opens the Gallery and allows the User to choose an Image to upload
    @IBAction func chooseImage(sender: AnyObject) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = false
        
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func createOfferBtnClicked(sender: AnyObject) {
        
        if descriptionTextField.text != "" && priceTextField.text != "" {
            
            self.createOffer()
            
        } else {
            
            let alert = UIAlertController(title: "Missing Data", message: "Please Fill in the Blanks", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action)-> Void in alert.dismissViewControllerAnimated(true, completion: nil)}))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}