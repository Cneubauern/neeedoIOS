//
//  OffersViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 10.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation


class Offers {
    
    var offerID = String()
    var version = Int()
    var userID = String()
    var userName = String()
    var tags = [String]()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var price = Float32()
    var images = [String]()
  
    
    class func createOffer(user:User, offer:Offer, completionhandler:(Bool?)->Void){
        
        let parameters:[String:AnyObject] = offer.generateParameters()
        
        Alamofire.request(.POST, "\(staticUrl)/offers", parameters: parameters, encoding: .JSON).authenticate(user: user.userEmail, password: user.userPassword).responseJSON { (Response) -> Void in
            
            if Response.result.isSuccess{
                
                completionhandler(true)
            } else{
                completionhandler(false)
            }
    
        }
        
    }

    class func updateOffer(offer: Offer, parameters: [String : AnyObject], completionhandler:(Bool?)->Void){
        
        Alamofire.request(.PUT, "\(staticUrl)/offers/\(offer.offerID)/\(offer.version)", parameters: parameters, encoding: .JSON).responseJSON { (Response) -> Void in
            if Response.result.isSuccess{
                completionhandler(true)
            } else{
                completionhandler(false)
            }
        }
    }
    
    class func deleteOffer(offer:Offer, completionHandler:(Bool?)->Void){
        Alamofire.request(.DELETE, "\(staticUrl)/offers/\(offer.offerID)/\(offer.version)").responseJSON { (Response) -> Void in
           
            if Response.result.isSuccess{
            
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    class func queryAllOffers(completionhandler:(NSArray?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)/offers").responseJSON { (Response) -> Void in
            
            if Response.result.isSuccess{
                
                if let JSON = Response.result.value as? NSArray{
                    
                    completionhandler(JSON)
                    
                }
                
            }
        }
        
    }
    
    class func queryAllOffersByUser(user:User, completionhandler:(NSArray?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)/users/\(user.userID)").responseJSON { (
            Response) -> Void in
            if Response.result.isSuccess{
                if let JSON = Response.result.value as? NSArray{
                    completionhandler(JSON)
                }
            }
        }
        
    }
    
    class func querySingleOfferById(offerID:String, completionhandler:(NSArray?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)/offers/\(offerID)").responseJSON{
            response in
            
            if response.result.isSuccess{
                
                if let JSON = response.result.value as? NSArray{
                    
                    completionhandler(JSON)
                    
                }
                
            }
            
        }
    }
    
    
    func generateParameters()->[String:AnyObject]{
        
        let parameters:[String:AnyObject] = [
            
            "userId": self.userID,
            "tags":self.tags,
            "images":self.images,
            "location":[
                "lat":self.latitude,
                "lon":self.longitude
            ],
            "price": self.price
        ]
        return parameters
    }
    
    

    
    
}

class Offer: Offers {

    init(userID: String, tags:[String], location: CLLocationCoordinate2D, price: Float32, images:[String]){
      
        super.init()
        self.userID = userID
        self.tags = tags
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.price = price
        self.images = images
    }
    
}