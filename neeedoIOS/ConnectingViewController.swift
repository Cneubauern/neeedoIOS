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
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()


    
    override func viewDidLoad() {
        print("Connecting")
        
        
        if  let user = NSUserDefaults.standardUserDefaults().stringForKey("UserName") {
            username = user
        }
        if  let mail = NSUserDefaults.standardUserDefaults().stringForKey("UserEmail") {
                email  = mail
        }
        if let  pass = NSUserDefaults.standardUserDefaults().stringForKey("UserPassword"){
            password = pass
            
        }

        print(username, email, password)
        
        
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
    
    
    func loginUser(){
        
        if signUpActive {
            
           signUpWithUsername()

        
        } else{
            LogInWithUsername()
        }
        
    }
    
    func userLoggedIn(){
        
        print("Login Success")
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UserLoggedIn")


        if signUpActive{
            
            finishedLogInAndLoading()
            
        }else{
            
            self.loadUserData()
        }
        
    }
    
    func signUpWithUsername(){
        
        print("signUp")
        
        let parameters = [
            
            "name":username,
            "email":email,
            "password":password
            
        ]
        
        Alamofire.request(.POST, "\(staticUrl)/users", parameters: parameters, encoding: .JSON).responseJSON { response in
            
            if response.result.isSuccess{
                
                if let JSON = response.result.value {
                    
                    print("\(JSON)")
                    
                    if let user = JSON["user"] as? NSDictionary{
                        
                        print("\(user)")
                        
                        
                        if let id = user["id"]  as? String{
                            
                            NSUserDefaults.standardUserDefaults().setObject("\(id)", forKey: "UserID")
                        
                        
                    }
                        if let version = user["version"] as? Int{
                            
                            NSUserDefaults.standardUserDefaults().setObject("\(version)", forKey: "UserVersion")
                            
                        }

                    
                }
                
                    self.userLoggedIn()
                
            } else {
                    
                    self.errorAlert()
                
            }
            
        }
        
    }
    }
    
    func LogInWithUsername(){
        
        print("logIn")
        
        
        let user = email
        let pass = password
        
        print(email , pass)
        
        Alamofire.request(.GET, "\(staticUrl)/users/mail/\(email)").authenticate(user: user, password: pass).responseJSON{response in

            if response.result.isSuccess{
                if let JSON = response.result.value {
                
                    print("\(JSON)")
                    
                    if let user = JSON["user"] as? NSDictionary{
                        
                        print("\(user)")
                        
                        if let name = user["name"] as? String{
                            
                            NSUserDefaults.standardUserDefaults().setObject("\(name)", forKey: "UserName")
                            
                        }
                        
                        
                        if let id = user["id"] as? String{
                            
                            NSUserDefaults.standardUserDefaults().setObject("\(id)", forKey: "UserID")
                            
                            
                        }
                        if let version = user["version"] as? String{
                            
                            NSUserDefaults.standardUserDefaults().setObject("\(version)", forKey: "userVersion")
                            
                        }
                        
                    }
                }

                self.userLoggedIn()
                
            } else {
                self.errorAlert()
            }
        }
    }

    func errorAlert(){
        
        let alert = UIAlertController(title: "Sorry", message:  "An Error occured while Logging You in ", preferredStyle: UIAlertControllerStyle.Alert)
        
        let goBack = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("loginError", sender: self)
        }
        
        alert.addAction(goBack)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    


    func loadUserData(){
        
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
    }
    
    func finishedLogInAndLoading(){
        activityIndicator.stopAnimating()
        self.performSegueWithIdentifier("loggedIn", sender: self)
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
}
