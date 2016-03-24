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

class CreateOfferViewController: UIViewController, UITextFieldDelegate,  CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    var myUser:User = User()
    var myNewOffer = Offers()
    var name = String()
    
    var locationManager = CLLocationManager()

    var chosenlocation = CLLocationCoordinate2D()

    var images = [UIImage]()
    var imagesData = [NSData]()
    var imageNames = [String]()
    var imageUrls = [NSURL]()
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var currentLocationSwitch: UISwitch!
    @IBOutlet var chooseLocationBtn: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        
        self.initUser()
        
        chooseLocationBtn.enabled = false
        
        imagePicker.delegate = self

        descriptionTextField.delegate = self
        priceTextField.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()


    }
    
    override func viewWillAppear(animated: Bool) {
        
        navigationController?.navigationBarHidden = true

    }
    
    override func viewDidAppear(animated: Bool) {
    

        self.setName()
    }
    
    func setName(){
        print("set name")
        print(self.name)
        self.descriptionTextField.text = name
        
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
        
        self.myUser.userLocation = userLocation.coordinate
        
    }
    
    func createOffer(){
        
        self.uploadImages { (name) -> Void in
            
            var imagesNamed = [String]()
            imagesNamed.append(name!)
        
    
            var coordinate = CLLocationCoordinate2D()
        
            if self.currentLocationSwitch.on {
            
                coordinate = self.myUser.userLocation
            } else{
            
                coordinate = self.chosenlocation
            }
        
        
            if let price = Float32(self.priceTextField.text!){
            
                if let tagsString = self.descriptionTextField.text {
                
                    let tags = tagsString.componentsSeparatedByString(",")
                
                    Offers.createOffer(self.myUser, offer: Offer(userID: self.myUser.userID, tags: tags, location: coordinate, price: price, images: imagesNamed), completionhandler: { (success) -> Void in
                   
                        if success == true {
                            print("created")
                            self.clearForm()
                        }
                    })
                }
            }else{
            
                print("Missing Elements")
        
            }
        }
    }
    
    //This function is called everytime the user is done picking or taking images
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
       
        if picker.sourceType == UIImagePickerControllerSourceType.Camera{
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.image = image
            
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
            
            // getting local path
            let date = NSDate()
            let localPath = (documentDirectory as NSString).stringByAppendingPathComponent("\(date).jpg")
            
            let data = UIImageJPEGRepresentation(image, 0.2)
            data!.writeToFile(localPath, atomically: true)
            
            let imageData = NSData(contentsOfFile: localPath)!
            
            self.imagesData.append(imageData)
            
            //  print(imageData)
            
            let imageURL = NSURL(fileURLWithPath: localPath)
            print(imageURL)
            self.imageUrls.append(imageURL)
            
            
        }
        
        if picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary{
            
            print("Image Selected")
            
            //getting details of image
            let uploadFileURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            
            if let imageName = uploadFileURL.lastPathComponent {
                
                imageNames.append(imageName)
                print(imageName)
                
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
                
                // getting local path
                let localPath = (documentDirectory as NSString).stringByAppendingPathComponent(imageName)
                
                //getting actual image
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                
                self.imageView.contentMode = .ScaleAspectFit
                self.imageView.image = image
                
                let data = UIImageJPEGRepresentation(image, 0.2)
                data!.writeToFile(localPath, atomically: true)
                
                let imageData = NSData(contentsOfFile: localPath)!
                
                self.imagesData.append(imageData)
                
                //  print(imageData)
                
                let imageURL = NSURL(fileURLWithPath: localPath)
                print(imageURL)
                self.imageUrls.append(imageURL)
            }

            
        }
        
        //picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
     
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    //This funtion sends the image to the needo API and makes sure they can be accessed in the createOffer - Method
    func uploadImages(completionHandler:(String?)->Void){
        
        let newImage = NeeedoImages()
        
        newImage.imageName = imageNames.last!
        newImage.imageUrl = imageUrls.last!
        newImage.data = imagesData.last!
        
        print(newImage.imageUrl,newImage.imageName)
        
        NeeedoImages.uploadImage( myUser, image: newImage) { (name) -> Void in
            
            completionHandler(name)
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) ->Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func chooseLocation(sender: AnyObject) {
        
        self.performSegueWithIdentifier("chooseLocationOffer", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let identifier = segue.identifier{

            if identifier == "chooseLocationOffer"{
            
                if let clvc =  segue.destinationViewController as? chooseLocationViewController{
                
                    clvc.identifier = identifier
                    clvc.location = self.myUser.userLocation
                }
            }
        }
    }
    
    @IBAction func useCurrentLocation(sender: AnyObject) {
        
        if currentLocationSwitch.on {
            
            chooseLocationBtn.enabled = false
            
        } else {
            chooseLocationBtn.enabled = true
        }
    }
    
    @IBAction func openScanner(sender: AnyObject) {
        
        performSegueWithIdentifier("barcode", sender: self)
    }
    
    // Opens the Camera and allows the User to take a Photo
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.imagePicker.allowsEditing = false
        
        self.presentViewController(self.imagePicker, animated: true) {
        }
    }
    
    //Opens the Gallery and allows the User to choose an Image to upload
    @IBAction func chooseImage(sender: AnyObject) {
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.imagePicker.allowsEditing = false
        
        
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
    
    func clearForm(){
        
        images.removeAll()
        imageNames.removeAll()
        imageUrls.removeAll()
        
        descriptionTextField.text = ""
        priceTextField.text = ""
        currentLocationSwitch.on = true
        chooseLocationBtn.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}