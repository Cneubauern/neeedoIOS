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
  
    func querySingleOffer(offerID:String){
        
        Alamofire.request(.GET, "\(staticUrl)/offers/\(offerID)")
        
    }
    
    
}

class Offer {
    
    var offerID = String()
    var version = Int()
    var userID = String()
    var userName = String()
    var tags = [String]()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var price = Float32()
    var images = [String]()
    
    init(userID: String, tags:[String], location: CLLocationCoordinate2D, price: Float32, images:[String]){
      
        self.userID = userID
        self.tags = tags
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.price = price
        self.images = images
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
    
    func updateOffer(offerID: String, version: Int, parameters: [String : AnyObject]){
        
        Alamofire.request(.PUT, "\(staticUrl)/offers/\(offerID)/\(version)", parameters: parameters, encoding: .JSON).responseJSON{ response in
            
            debugPrint(response)
        }
    }
    
    func deleteOffer(offerID: String, version: Int){
        Alamofire.request(.DELETE, "\(staticUrl)/offers/\(offerID)/\(version)").responseJSON{
            response in
            debugPrint(response)
        }
    }

    
    
}