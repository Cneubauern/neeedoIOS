//
//  DemandsViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 10.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import CoreLocation

class Demands{
    
    var demandID = String()
    var version = Int()
    var userID = String()
    var userName = String()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var distance = Float32()
    var minPrice = Float32()
    var maxPrice = Float32()
    var mustTags = [String]()
    var shouldTags = [String]()
    
    
    class func createDemand(user:User, demand:Demand, completionhandler:(Bool?)->Void){
        
        let parameters:[String:AnyObject] = demand.generateParameters()
        
        print(parameters)
        
        print(user.userEmail, user.userPassword)
        
        Alamofire.request(.POST, "\(staticUrl)/demands", parameters: parameters, encoding: .JSON).authenticate(user: user.userEmail, password: user.userPassword).responseJSON(completionHandler: { (Response) -> Void in
            
            debugPrint(Response)
            
            if Response.result.isSuccess{
            
                completionhandler(true)
                
            }else{
                
                completionhandler(false)
            }
        })
    }
    
    class func queryDemandsByUser(user:User, completionhandler:(NSArray?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)/demands/users/\(user.userID)").responseJSON(completionHandler: { (Response) -> Void in
            
            if Response.result.isSuccess{
                
                debugPrint(Response)
                
                if let JSON = Response.result.value{
                 
                    if let demands = JSON["demands"] as? NSArray{

                        completionhandler(demands)
                    }
                }
            }
        })
    }
    
    class func queryAllDemands(completionhandler: (NSArray?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)/demands").responseJSON(completionHandler: { (Response) -> Void in
            
            debugPrint(Response)

            if Response.result.isSuccess{
                if let JSON = Response.result.value{
                    if let demands = JSON["demands"] as? NSArray{
                      
                        completionhandler(demands)
                    }
                }
            }
        })
    }
    
    func querySingleDemand(demandID:String, completionhandler:(NSDictionary?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)/demands/\(demandID)").responseJSON(completionHandler: { (Response) -> Void in
        
            debugPrint(Response)
           
            if Response.result.isSuccess{
                
                if let JSON = Response.result.value{
                    
                    if let demand = JSON["demand"] as? NSDictionary{
                    
                        completionhandler(demand)
                    }
                }
            }
        })
    }

    
    func generateParameters()->[String:AnyObject]{
        
        let parameters:[String:AnyObject] = [
            
            "userId": self.userID,
            "mustTags":self.mustTags,
            "shouldTags":self.shouldTags,
            "location":[
                "lat":self.latitude,
                "lon":self.longitude
            ],
            "distance":self.distance,
            "price":[
                "min":self.minPrice,
                "max":self.maxPrice
            ]
        ]
        return parameters
    }


    class func updateDemand(demand:Demands, parameters: [String : AnyObject], completionhandler:(Bool?)->Void){
        
        Alamofire.request(.PUT, "\(staticUrl)/demands/\(demand.demandID)/\(demand.version)", parameters: parameters, encoding: .JSON).responseJSON(completionHandler: { (Response) -> Void in
            
            debugPrint(Response)

            if Response.result.isSuccess{
                completionhandler(true)
            }else{
                completionhandler(false)
            }
        })
    }
    
    class func deleteDemand(demand:Demands, completionhandler:(Bool?)->Void){
        
        Alamofire.request(.DELETE, "\(staticUrl)/\(demand.demandID)/\(demand.version)").responseJSON(completionHandler: { (Response) -> Void in
            
            debugPrint(Response)
        
            if Response.result.isSuccess{
                
                completionhandler(true)
            
            } else {
            
                completionhandler(false)
            
            }
        })
    }

    class func demandGetMatchingOffers(user:User, demand:Demand, completionhandler:(NSArray?)->Void){
        
        let parameters = demand.generateParameters()
        
        Alamofire.request(.POST, "\(staticUrl)/matching/demand", parameters: parameters, encoding: .JSON).authenticate(user: user.userEmail, password: user.userPassword).responseJSON(completionHandler: { (Response) -> Void in
            
            debugPrint(Response)
            
            if Response.result.isSuccess{
            
                if let JSON = Response.result.value{
                    
                    if let offers = JSON["offers"] as? NSArray{
                        
                        completionhandler(offers)
                    }
                }
            }
        })
    }
    
}

class Demand: Demands {
    
    init(user:User, mustTags:[String], shouldTags:[String], location: CLLocationCoordinate2D, distance:Float32, minPrice: Float32, maxPrice: Float32){
      
        super.init()
        self.userID = user.userID
        self.userName = user.userName
        self.mustTags = mustTags
        self.shouldTags = shouldTags
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.distance = distance
        self.minPrice = minPrice
        self.maxPrice = maxPrice
    }
}



/*
    let newDemand = Demands()
    
    if let id = demand["id"] as? String{
        
        newDemand.demandID = id
    }
    if let version =  demand["version"] as? Int{
        
        newDemand.version = version
    }
    if let user = demand["user"] as? NSDictionary{
        
        if let userId = user["id"] as? String{
            
            newDemand.userID = userId
        }
        if let username = user["name"] as? String{
            
            newDemand.userName = username
        }
    }
    if let must = demand["mustTags"] as? [String]{
        
        newDemand.mustTags = must
    }
    if let should = demand["shouldTags"] as? [String]{
        
        newDemand.shouldTags = should
    }
    if let location = demand["location"] as? NSDictionary{
        
        if let lat = location["lat"] as? CLLocationDegrees{
            
            newDemand.latitude = lat
        }
        if let lon = location["lon"] as? CLLocationDegrees{
            newDemand.longitude = lon
        }
    }
    if let distance = demand["distance"] as? Float32{
        
        newDemand.distance = distance
    }
    if let price = demand["price"] as? NSDictionary{
        
        if let min = price["min"] as? Float32{
            
            newDemand.minPrice = min
        }
        if let max = price["max"] as? Float32{
            
            newDemand.maxPrice  = max
        }
}*/