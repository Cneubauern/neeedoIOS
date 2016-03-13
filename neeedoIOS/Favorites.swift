//
//  Favorites.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 13.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire

class Favorites {
    
    var userID = String()
    var offerID = String()
    var offer = Offers()
    
  
    class func addFavorite(user:User, offer:Offer, completionhandler:(Bool?)->Void){
        
        let parameters:[String:AnyObject] = [
            
            "userId": user.userID,
            "offerId": offer.offerID
        ]
        
        Alamofire.request(.POST, "\(staticUrl)/favorites", parameters: parameters, encoding: .JSON).responseJSON { (Response) -> Void in
            
            if Response.result.isSuccess{
                completionhandler(true)
            }
        }
    }
    
    class func getFavoritesByUser(user:User, completionhandler:(NSArray?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)favorites/\(user.userID)").responseJSON { (Response) -> Void in
            
            if Response.result.isSuccess{
              
                if let JSON = Response.result.value{
                
                    if let favorites = JSON["favorites"] as? NSArray{
                        completionhandler(favorites)
                    }
                }
            }
        }
    }
    
    func removeFavorite(user:User, offer:Offer, completionhandler:(Bool?)->Void){
        
        Alamofire.request(.DELETE, "\(staticUrl)/favorites/:\(user.userID)/:\(offer.offerID)").responseJSON { (Response) -> Void in
            if Response.result.isSuccess{
                completionhandler(true)
            }else{
                completionhandler(false)
            }
        }
    }

}

class Favorite: Favorites {
    
    init(user:User, offer:Offer) {
        super.init()
        self.userID = user.userID
        self.offerID = offer.offerID
        
    }
}