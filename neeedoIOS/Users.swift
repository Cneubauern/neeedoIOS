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
    
    func createUser(username: String, email: String, passwd: String){
        
        let parameters:[String:AnyObject]  = [
            
            "name": username,
            "email": email,
            "password":passwd
        ]
        
        Alamofire.request(.POST, "\(staticUrl)/user", parameters: parameters, encoding: .JSON).responseJSON{
            response in
            
            debugPrint(response)
        }
    }
    
    func deleteUser(id:String, version: Int){
        
        Alamofire.request(.DELETE, "\(staticUrl)/users/\(id)/\(version)").responseJSON{
            
            response in
            
            debugPrint(response)
        }
        
    }
    
}



class UserbyPassword: User {
   
    var username = String()
    var userEmail = String()
    var userPassword = String()

    init(name: String, email: String, pass:String){
        self.username = name
        self.userEmail = email
        self.userPassword = pass

    }

    func querySingleUserByEmail(email:String)->UserById{
        
        var queryId = String()
        var queryEmail = String()
        var queryVersion = Int()
        
        
        Alamofire.request(.GET, "\(staticUrl)/users/mail/\(email)").authenticate(user: self.userEmail, password: self.userPassword).responseJSON{
            response in
            
            if response.result.isSuccess{
                
                if let JSON = response.result.value{
                    if let user = JSON["user"] as? NSDictionary{
                        if let id = user["id"] as? String{
                            queryId = id
                        }
                        if let mail = user["email"] as? String{
                            queryEmail = mail
                        }
                        if let version = user["version"] as? Int {
                            queryVersion = version
                        }
                    }
                }
            }
        }
        
        
        let queryUser = UserById(email: queryEmail, id: queryId, version: queryVersion)
        return queryUser
    }

}

class UserById: User{

    var username = String()
    var userID = String()
    var userEmail = String()
    var userPassword = String()
    var version = Int()

    init(email: String, id: String, version: Int) {
        
        self.userID = id
        self.userEmail = email
        self.version = version
    }
    
}

