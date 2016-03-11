//
//  ConnectingViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 27.02.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData

let staticUrl = "https://www.neeedoapi.cneubauern.de"
let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let context:NSManagedObjectContext = appDel.managedObjectContext


class ConnectingViewController: UIViewController {
    
    var username:String = String()
    var email:String = String()
    var password:String = String()
    var userId:String = String()
    var version:Int = Int()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    var signUpActive = Bool()
    var myUser:User = User()

    
    override func viewDidLoad() {
       
        print("Connecting")
        
        username = myUser.userName
        email  = myUser.userEmail
        password = myUser.userPassword
        userId = myUser.userID
        version = myUser.userVersion
        
        print(username, email, password, userId, version)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            loginUser()
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func fillUserDefaults(){
        
        myUser.completeUser(){ name, id, version in
            
            self.myUser.userID = id!
            self.myUser.userVersion = version!
        }
        
        NSUserDefaults.standardUserDefaults().setObject(myUser.userName, forKey: "UserName")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userEmail, forKey: "UserEmail")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userPassword, forKey: "UserPassword")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userID, forKey: "UserID")
        NSUserDefaults.standardUserDefaults().setObject(myUser.userVersion, forKey: "UserVersion")

    }
    
    func loginUser(){
        
        if signUpActive {
            
            print("signUp")
            
            
            User.createUser(myUser.userName, email: myUser.userEmail, passwd: myUser.userPassword,completionhandler:{ success in
              
                if success == true{

                    self.userLoggedIn()

                } else {
                    
                    self.errorAlert()
                }
            })
        
        } else{

            myUser.checkUser(){ success in
                
                if success == true {
               
                    self.userLoggedIn()
                
                } else {
                
                    self.errorAlert()
                }
            }
        }
        
    }
    
    func userLoggedIn(){
        
        print("Login Success")
        
        self.fillUserDefaults()
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UserLoggedIn")


        if signUpActive{
            
            finishedLogInAndLoading()
            
        }else{
            
           // self.loadUserData()
        }
        
    }
    
    func errorAlert(){
        
        print("loginError")
        
        let alert = UIAlertController(title: "Sorry", message:  "An Error occured while Logging You in ", preferredStyle: UIAlertControllerStyle.Alert)
        
        let goBack = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("loginError", sender: self)
        }
        
        alert.addAction(goBack)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    


  /*  func loadUserData(){
        
        print("We will load the Data now")
        
        let userId = NSUserDefaults.standardUserDefaults().stringForKey("UserID")!
        
        print(userId)
        
        var newDemand = NSEntityDescription.insertNewObjectForEntityForName("Demands", inManagedObjectContext: context)

        var newOffer = NSEntityDescription.insertNewObjectForEntityForName("Offers", inManagedObjectContext: context)
        
        let requestOffers = NSFetchRequest(entityName: "Offers")
        let requestDemands = NSFetchRequest(entityName: "Demands")
        
        requestDemands.returnsObjectsAsFaults = false
        requestOffers.returnsObjectsAsFaults = false

        
        var addOffer  = true
        var addDemand = true

       Alamofire.request(.GET, "\(staticUrl)/offers/users/\(userId)").responseJSON{ response in
        
        debugPrint(response)
            if response.result.isSuccess {
                
                if let JSON = response.result.value {
                    
                    //print(JSON)
                    
                    if let offers = JSON["offers"] as? NSArray{
                        
                       // print(offers)
                      
                        for offer in offers {
                          //  print(offer)
                            
                            if let id = offer["id"] as? String{
                        //        print (id)
                                newOffer.setValue(id, forKey: "id")
                                
                                requestOffers.predicate = NSPredicate(format: "id = %@", id)
                                
                                do{
                                    let search = try context.executeFetchRequest(requestOffers)
                                    
                                    if search.count > 0{
                                        print(search)
                                        
                                        addOffer = false
                                    } else {
                                        addOffer = true

                                    }
                                    
                                } catch {
                                    
                                    
                                }
                                
                            }
                            if let images = offer["images"] as? String{
                                
                           //     print(images)
                                newOffer.setValue(images, forKey: "images")

                                
                            }
                            if let location = offer["location"] as? NSDictionary{
                                
                                if let lat = location["lat"]{
                             //       print(lat)
                                    newOffer.setValue(lat, forKey: "lat")

                                }
                                if let lon = location["lon"]{
                             //       print(lon)
                                    newOffer.setValue(lon, forKey: "lon")

                                }
                                
                            }
                            if let price = offer["price"] as? Double{
                             //   print(price)
                                newOffer.setValue(price, forKey: "price")

                            }
                            if let tags = offer["tags"] as? String{
                              //  print(tags)
                                newOffer.setValue(tags, forKey: "tags")

                            }
                            if let user = offer["user"] as? NSDictionary{
                                
                                if let id = user["id"] as? String{
                                //    print(id)
                                    newOffer.setValue(id, forKey: "userId")

                                }
                                if let name = user["name"] as? String{
                                  //  print(name)
                                    newOffer.setValue(name, forKey: "userName")

                                }
                            }
                            if let version = offer["version"] as? Int{
                                // print(version)
                                newOffer.setValue(version, forKey: "version")

                            }
                            if addOffer{
                                do{
                                    try context.save()
                                }catch{
                                    print("Error Saving offer")
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
        
        Alamofire.request(.GET, "\(staticUrl)/demands/users/\(userId)").responseJSON{ response in
            
            debugPrint(response)

            if response.result.isSuccess{
                
                if let JSON = response.result.value{
                    
                    //print(JSON)
                    
                    if let demands = JSON["demands"] as? NSArray{
                      //  print(demands)
                        
                        for demand in demands {
                            
                          //  print(demand)
                            
                            if let distance = demand["distance"] as? Double{
                              //  print(distance)
                                newDemand.setValue(distance, forKey: "distance")
                            }
                            if let id = demand["id"] as? String{
                               // print(id)
                                newDemand.setValue(id, forKey: "id")
                                
                                requestDemands.predicate = NSPredicate(format: "id = %@", id)
                                
                                do{
                                    let search = try context.executeFetchRequest(requestDemands)
                                    
                                    if search.count > 0{
                                        print(search)
                                        
                                        addDemand = false
                                    } else {
                                        addDemand = true
                                        
                                    }

                                } catch {
                                    
                                    
                                }

                            }
                            if let location = demand["location"] as? NSDictionary{
                                if let lat = location["lat"]{
                               //     print(lat)
                                    newDemand.setValue(lat, forKey: "lat")

                                }
                                if let lon = location["lon"]{
                                //    print(lon)
                                    newDemand.setValue(lon, forKey: "lon")

                                }
                            }
                            if let mustTags = demand["mustTags"] as? String{
                              //  print(mustTags)
                                newDemand.setValue(mustTags, forKey: "mustTags")

                            }
                            if let price = demand["price"] as? NSDictionary{
                                if let max = price["max"]{
                                //    print(max)
                                    newDemand.setValue(max, forKey: "maxPrice")

                                }
                                if let min = price["min"]{
                               //     print(min)
                                    newDemand.setValue(min, forKey: "minPrice")

                                }                            }
                            if let shouldTags = demand["shouldTags"] as? String{
                               // print(shouldTags)
                                newDemand.setValue(shouldTags, forKey: "shouldTags")

                            }
                            if let user = demand["user"] as? NSDictionary{
                                if let id = user["id"] as? String{
                                //    print(id)
                                    newDemand.setValue(id, forKey: "userId")

                                }
                                if let name = user["name"] as? String{
                                //    print(name)
                                    newDemand.setValue(name, forKey: "userName")

                                }}
                            if let version = demand["version"] as? Int {
                             //   print(version)
                                newDemand.setValue(version, forKey: "version")

                            }
                            if addDemand{
                                do{
                                    try context.save()
                                    
                                } catch {
                                    print("there was an error saving the demand")
                                }
                                
                            }
                        
                        }
                    }
                }
            }
        }
        self.finishedLogInAndLoading()
    }*/
    
    func finishedLogInAndLoading(){
        activityIndicator.stopAnimating()
        self.performSegueWithIdentifier("loggedIn", sender: self)
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
}
