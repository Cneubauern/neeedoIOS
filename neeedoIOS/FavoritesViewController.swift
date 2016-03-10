//
//  Favorites.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 10.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class FavoritesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addFavorite(userID:String, offerID: String){
        
        let parameters:[String:AnyObject] = [
            
            "userId": userID,
            "offerId": offerID
        ]
        
        Alamofire.request(.POST, "\(staticUrl)/favorites", parameters: parameters, encoding: .JSON).responseJSON{
            response in
            
            debugPrint(response)
        }
        
    }
    
    func getFavoritesByUser(userID:String){
        
        Alamofire.request(.GET, "\(staticUrl)favorites/\(userID)").responseJSON{
            response in
            
            debugPrint(response)
        }
        
    }
    
    func removeFavorite(userID:String, offerID:String){
        
        Alamofire.request(.DELETE, "\(staticUrl)/favorites/:\(userID)/:\(offerID)").responseJSON{
            response in
            
            debugPrint(response)
        }
        
    }
}