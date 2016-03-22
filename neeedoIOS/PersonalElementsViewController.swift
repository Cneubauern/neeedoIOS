//
//  PersonalElementsViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 28.02.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import MapKit

class PersonalElementsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var viewSwitch: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
   
    var myUser = User()
    
    var list = String()
    
    var myFavorites = [Offers]()
    var myDemands = [Demands]()
    var myOffers = [Offers]()
    
    var offer = Offers()
    var demand = Demands()
    
    override func viewDidLoad() {
        // Stuff
        
        self.getUser()
        self.getFavorites()
        self.getOffers()
        self.getDemands()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeView(sender: AnyObject) {
        
        tableView.reloadData()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        var numberOfRows = Int()
        
        switch self.list{

            
        case "Favorites":
            numberOfRows = myFavorites.count
        case "Offers":
            numberOfRows = myOffers.count
        case "Demands":
            numberOfRows = myDemands.count
        default:
            numberOfRows = 0
            
        }
        
        print("nor:",numberOfRows)
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        

        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let noImage = UIImage(named: "noimage")
        let offerImage = UIImage(named: "noimage")
        let demandImage = UIImage(named: "noimage")
        let favoriteImage = UIImage(named: "218-star-full")
        
        switch self.list{
            
        case "Favorites":
            
            cell.textLabel?.text = myFavorites[indexPath.row].tags.joinWithSeparator(",")
            cell.imageView?.image = favoriteImage
            
        case "Offers":
           
            cell.textLabel?.text = myOffers[indexPath.row].tags.joinWithSeparator(",")
            cell.imageView?.image = offerImage


        case "Demands":
            cell.textLabel?.text = myDemands[indexPath.row].mustTags.joinWithSeparator(",")
            cell.imageView?.image = demandImage
            
        default:
            cell.textLabel?.text = "bla"
            cell.imageView?.image = noImage
        }
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier{
            
            if identifier == "showOffer"{
                
                if let ovc =  segue.destinationViewController as? OfferViewController{
                    
                    ovc.myOffer = self.offer
                    
                }
            }
            if identifier == "showDemand"{
                
                if let dvc =  segue.destinationViewController as? DemandViewController{
                    
                    dvc.myDemand = self.demand
                    
                }
            }
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch self.list{
     
        case "Favorites":
            self.offer = self.myFavorites[indexPath.row]
            self.performSegueWithIdentifier("showOffer", sender: self)
        case "Offers":
            self.offer = self.myOffers[indexPath.row]
            self.performSegueWithIdentifier("showOffer", sender: self)
        case "Demands":
            self.demand = self.myDemands[indexPath.row]
            self.performSegueWithIdentifier("showDemand", sender: self)
        default:
            self.offer = self.myFavorites[indexPath.row]
            self.performSegueWithIdentifier("showOffer", sender: self)
        }
    }
    
    func getUser(){
        
        self.myUser.userEmail = NSUserDefaults.standardUserDefaults().stringForKey("UserEmail")!
        self.myUser.userPassword = NSUserDefaults.standardUserDefaults().stringForKey("UserPassword")!
        
        if let id = NSUserDefaults.standardUserDefaults().stringForKey("UserID"){
            
            self.myUser.userID = id
        }
    }

    func getFavorites(){
        
        Favorites.getFavoritesByUser(myUser) { (favorites)-> Void in
            
            for favorite in favorites! {
                
                let newFav = Offers()
                
                if let id = favorite["id"] as? String{
                  
                    newFav.offerID = id
                }
                if let version = favorite["version"] as? Int {
                  
                    newFav.version = version
                }
                if let user = favorite["user"] as? NSDictionary{
                    if let uid = user["id"] as? String{
                        newFav.userID = uid
                    }
                    if let name = user["name"] as? String{
                        newFav.userName = name
                    }
                }
                if let tags = favorite["tags"] as? [String]{
                    newFav.tags = tags
                }
                if let location = favorite["location"] as? NSDictionary{
                    if let lat = location["lat"] as? CLLocationDegrees{
                        newFav.latitude = lat
                    }
                    if let lon = location["lon"] as? CLLocationDegrees{
                        newFav.longitude = lon
                    }
                }
                if let price = favorite["price"] as? Float32{
                    
                    newFav.price = price
                }
                if let images = favorite["images"] as? [String]{

                    newFav.images = images
                }
                
                self.myFavorites.append(newFav)
            }
        }
    }
    func getOffers(){
        
        Offers.queryAllOffersByUser(myUser, completionhandler: { (offers) -> Void in
            
            for offer in offers! {
            
                let newOffer = Offers()
                
                if let id = offer["id"] as? String{
                    
                    newOffer.offerID = id
                }
                if let version = offer["version"] as? Int {
                    
                    newOffer.version = version
                }
                if let user = offer["user"] as? NSDictionary{
                    if let uid = user["id"] as? String{
                        newOffer.userID = uid
                    }
                    if let name = user["name"] as? String{
                        newOffer.userName = name
                    }
                }
                if let tags = offer["tags"] as? [String]{
                    newOffer.tags = tags
                }
                if let location = offer["location"] as? NSDictionary{
                    if let lat = location["lat"] as? CLLocationDegrees{
                        newOffer.latitude = lat
                    }
                    if let lon = location["lon"] as? CLLocationDegrees{
                        newOffer.longitude = lon
                    }
                }
                if let price = offer["price"] as? Float32{
                    
                    newOffer.price = price
                }
                if let images = offer["images"] as? [String]{
                    
                    newOffer.images = images
                }
                
                self.myOffers.append(newOffer)
            }
        })
    }

    func getDemands(){
        
        Demands.queryDemandsByUser(myUser) { (demands) -> Void in
        
            for demand in demands! {
                
                let newDemand = Demands()
                
                if let id = demand["id"] as? String{
                    
                    newDemand.demandID = id
                }
                if let version = demand["version"] as? Int {
                    
                    newDemand.version = version
                }
                if let user = demand["user"] as? NSDictionary{
                    if let uid = user["id"] as? String{
                        newDemand.userID = uid
                    }
                    if let name = user["name"] as? String{
                        newDemand.userName = name
                    }
                }
                if let mustTags = demand["mustTags"] as? [String]{
                    newDemand.mustTags = mustTags
                }
                if let shouldTags = demand["shouldTags"] as? [String]{
                    newDemand.shouldTags = shouldTags
                }
                if let location = demand["location"] as? NSDictionary{
                    if let lat = location["lat"] as? CLLocationDegrees{
                        newDemand.latitude = lat
                    }
                    if let lon = location["lon"] as? CLLocationDegrees{
                        newDemand.longitude = lon
                    }
                }
                if let distance = demand["distance"] as? Float32 {
                    newDemand.distance = distance
                }
                if let price = demand["price"] as? NSDictionary{
                    
                    if let min = price["min"] as? Float32{
                        newDemand.minPrice = min
                    }
                    if let max = price["max"] as? Float32{
                        newDemand.maxPrice = max
                    }
                }
                self.myDemands.append(newDemand)
            }
        }
    }

        
 
}