//
//  Messages.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 13.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire

class Messages {
    
    var messageID = String()
    var senderID = String()
    var senderName = String()
    var recipientID = String()
    var recipientName = String()
    var body = String()
    var timeStamp = Int()
    var read = Bool()
    
    class func sendMessage(message:Message, completionhandler:(Bool?)->Void){
        
        let parameters:[String : AnyObject] = [
            
            "senderId": message.senderID,
            "recipientID": message.recipientID,
            "body": message.body
        ]
        
        Alamofire.request(.POST, "\(staticUrl)/messages", parameters: parameters, encoding: .JSON).responseJSON { (Response) -> Void in
            
            if Response.result.isSuccess{
                completionhandler(true)
            }else{
                completionhandler(false)
            }
        }
    }

    
    class func readMessages(user_1:User, user_2:User, completionhandler:(NSArray?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)/messages/\(user_1.userID)/\(user_2.userID)").responseJSON { (Response) -> Void in
        
            if Response.result.isSuccess{
                
                if let JSON = Response.result.value{
                
                    if let messages = JSON["messages"]as? NSArray{
                    
                        completionhandler(messages)
                    
                    }
                }
            }
        }
    }

    func markMessageAsRead(completionhandler:(Bool?)->Void){
        
        Alamofire.request(.PUT, "\(staticUrl)/messages/\(self.messageID)").responseJSON { (Response) -> Void in
            
            if Response.result.isSuccess{
                
                completionhandler(true)
                
            }
        }
    }
    
    class func getAllConversationsByUser(user:User, read:Bool, completionhandler:(NSArray?)->Void){
        
        Alamofire.request(.GET, "\(staticUrl)/messages/\(user.userID)?read=\(read)").responseJSON { (Response) -> Void in
            
            if Response.result.isSuccess{
                
                if let JSON = Response.result.value{
                
                    if let users = JSON["users"] as? NSArray{
                        
                        completionhandler(users)
                        
                    }
                }
            }
        }
    }
}

class Message: Messages {

    init(sender:User, recipient:User, message:String) {
        super.init()
        self.senderID = sender.userID
        self.senderName = sender.userName
        self.recipientID = recipient.userID
        self.senderName = recipient.userName
        self.body = message
    }
}