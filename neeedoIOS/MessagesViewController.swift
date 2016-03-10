//
//  MessagesViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 10.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class MessagesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendMessage(){
        
        let userID = NSUserDefaults.standardUserDefaults().stringForKey("UserID")!
        
        let recID = "98d40e3e-1c50-43f3-9ba5-58497b417d01"
        
        let body = "Testmessage"
        
        let parameters:[String : AnyObject] = [
            
            "senderId": userID,
            "recipientID": recID,
            "body": body
            ]
        
        print(parameters)
        

        Alamofire.request(.POST, "\(staticUrl)/messages", parameters: parameters, encoding: .JSON).responseJSON{response in
            
            debugPrint(response)
            
        }
    }
    
    func readMessages(user_1:String, user_2: String){
        
        Alamofire.request(.GET, "\(staticUrl)/messages/\(user_1)/\(user_2)").responseJSON{
            response in
            
            debugPrint(response)
        }
        
    }
    
    func markMessageAsRead(messageID:String){
        
        Alamofire.request(.PUT, "\(staticUrl)/messages/\(messageID)").responseJSON{
            response in
            
            debugPrint(response)
        }
    }
    
    func getAllConversations(read:Bool){
        
        let userID = NSUserDefaults.standardUserDefaults().stringForKey("UserID")!
        
        
        Alamofire.request(.GET, "\(staticUrl)/messages/\(userID)?read=\(read)").responseJSON{ response in
            
            debugPrint(response)
        }

    }
    
}
