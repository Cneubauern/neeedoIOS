//
//  ConversationsViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 23.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ConversationsViewController: UITableViewController {
    
    var myUser = User()
    var conversations = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getConversations(){
        
        Messages.getAllConversationsByUser(myUser, read: <#T##Bool#>) { (users) -> Void in
            
            for user in users!{
                let newUser = User()
                if let id = user["id"] as? String{
                    newUser.userID = id
                }
                if let name = user["name"] as? String{
                    newUser.userName = name
                }
                self.conversations.append(newUser)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        return self.conversations.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")

        cell.textLabel?.text = conversations[indexPath.row].userName
    }

}