//
//  MatchingViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 07.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class MatchingViewController: UIViewController {
    
    @IBOutlet var tags: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var offerView: UIView!
    
    var demand:Demands = Demands()
    
    var matchingOffers = [Offers]()
    
    var myUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUser()
            
        self.getMatchingOffers()
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))

        offerView.addGestureRecognizer(gesture)
        
        offerView.userInteractionEnabled = true
        
    }
    
    func initUser(){
        
        self.myUser.userEmail = NSUserDefaults.standardUserDefaults().stringForKey("UserEmail")!
        self.myUser.userPassword = NSUserDefaults.standardUserDefaults().stringForKey("UserPassword")!
        
        if let id = NSUserDefaults.standardUserDefaults().stringForKey("UserID"){
            
            self.myUser.userID = id
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMatchingOffers(){
        
        Demands.demandGetMatchingOffers(myUser, demand: demand as! Demand) { (offers) -> Void in
            
            for offer in offers!{
                
                let match = Offers()
                
                if let id = offer["id"] as? String{
                    
                    match.offerID = id
                }
                if let version = offer["version"] as? Int{
                
                    match.version = version
                }
                if let tags = offer["tags"] as? [String]{
                
                    match.tags = tags
                    
                }
                if let location = offer["location"] as? NSDictionary{
                    
                    var coordinate = CLLocationCoordinate2D()
                    
                    if let lat = location["lat"] as? CLLocationDegrees{
                        coordinate.latitude = lat
                    }
                    if let lon = location["lon"] as? CLLocationDegrees{
                        coordinate.longitude = lon
                    }
                    match.latitude = coordinate.latitude
                    match.longitude = coordinate.longitude
                }
                
                if let price = offer["price"] as? Float32{
                
                    match.price = price
                }
                
                if let user = offer["user"] as? NSDictionary{
                    
                    if let userID = user["id"] as? String{
                        match.userID = userID
                    }
                    if let name = user["name"] as? String{
                    
                        match.userName = name
                    }
                }
                    
                if let images = offer["images"] as? [String]{
                    
                    match.images = images
                }
                
                self.matchingOffers.append(match)
            }
        }
    }
    
    func wasDragged(gesture:UIPanGestureRecognizer){
        
        let translation = gesture.translationInView(self.view)
        
        let myView = gesture.view!
        
        myView.center = CGPoint(x: self.view.bounds.width/2 + translation.x, y: self.view.bounds.height/2 + translation.y)
        
        let xFromCenter = myView.center.x - self.view.bounds.width/2
        
        let scale = min(100 / abs(xFromCenter),1)
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter/200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        myView.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended{
            
            if myView.center.x < 100{
                
                print("not chosen")
                
            } else if myView.center.x > self.view.bounds.width-100{
                
                print("chosen")
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            myView.transform = stretch
            
            myView.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        }
        
        print(translation)
    }

    @IBAction func dismissOffer(sender: AnyObject) {
    }
    @IBAction func chooseOffer(sender: AnyObject) {
    }
    
}

