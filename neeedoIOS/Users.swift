//
//  Users.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 10.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire


class User{
    
    var userName = String()
    var userID = String()
    var userEmail = String()
    var userPassword = String()
    var userVersion = Int()
    
    class func createUser(user:User, completionhandler:(Bool?)->Void){
        
        print("Creating new User")
        
        let parameters:[String:AnyObject]  = [
            
            "name": user.userName,
            "email": user.userEmail,
            "password":user.userPassword
        ]
        
        Alamofire.request(.POST, "\(staticUrl)/users", parameters: parameters, encoding: .JSON).responseJSON(completionHandler: { (Response) -> Void in
            debugPrint(Response)
            
            if Response.result.isSuccess{
                
                completionhandler(true)
                
            } else{
                
                completionhandler(false)
            }

            })
    }
    
    class func deleteUser(user:User, completionhander:(Bool?)->Void){
        
        print("Deleting User")
        
        if user.userVersion != 0 && user.userID != ""{
            
        
            Alamofire.request(.DELETE, "\(staticUrl)/users/\(user.userID)/\(user.userVersion)").responseJSON(completionHandler: { (Response) -> Void in
                
                debugPrint(Response)

                if Response.result.isSuccess{

                    completionhander(true)
                
                } else {
                    
                    completionhander(false)
                    
                }
            })
        }
        
    }
    
    func completeUser(completionhandler:(String?,String?,Int?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)/users/mail/\(self.userEmail)").authenticate(user: self.userEmail, password: self.userPassword).responseJSON(completionHandler: { (Response) -> Void in
        
            if Response.result.isSuccess{
                
                if let JSON = Response.result.value{
                    if let user = JSON["user"] as? NSDictionary{
                        if let name = user["name"] as? String{
                            if let id = user["id"] as? String {
                                if let version = user["version"] as? Int{
                                    
                                    completionhandler(name, id, version)
                                    
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func checkUser(completionhandler: (Bool?) ->Void){
    
        Alamofire.request(.GET, "\(staticUrl)/users/mail/\(self.userEmail)").authenticate(user: self.userEmail, password: self.userPassword).responseJSON(completionHandler: { (Response) -> Void in
         
            if Response.result.isSuccess{
            
                completionhandler(true)
            
            }else{
            
                completionhandler(false)
            }
        })
        
    }
    
}

