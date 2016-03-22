//
//  OfferViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 16.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class OfferViewController:  UIViewController{
   
    @IBOutlet var offerImage: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var priceEdit: UITextField!
    @IBOutlet var tagsLabel: UILabel!
    @IBOutlet var tagsEdit: UITextField!
    @IBOutlet var sendBtn: UIButton!
    
    var myOffer = Offers()
    
    var edit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offerImage.image = UIImage(named: "noImage")
        userLabel.text = myOffer.userName
        priceLabel.text = "\(myOffer.price)"
        tagsLabel.text = myOffer.tags.joinWithSeparator(",")
        
        tagsEdit.hidden = true
        priceEdit.hidden = true
        sendBtn.hidden = true
        
    }
    
    func switchView(){
        if edit {
            
            offerImage.hidden = false
            priceLabel.hidden = false
            tagsLabel.hidden = false
            
            priceLabel.text = "\(myOffer.price)"
            tagsLabel.text = myOffer.tags.joinWithSeparator(",")
            
            tagsEdit.hidden = true
            priceEdit.hidden = true
            sendBtn.hidden = true
            
            
        } else {
            
            tagsEdit.hidden = false
            priceEdit.hidden = false
            sendBtn.hidden = false
            
            priceLabel.hidden = true
            tagsLabel.hidden = true
            
          
            tagsEdit.placeholder = myOffer.tags.joinWithSeparator(",")
            priceEdit.placeholder = "\(myOffer.price)"
        }
    }
    
    @IBAction func editBtnPressed(sender: AnyObject) {
        
        self.switchView()
        
    }
    @IBAction func trashBtnPressed(sender: AnyObject) {
        
        Offers.deleteOffer(myOffer) { (success) -> Void in
            if success == true {
                
                self.performSegueWithIdentifier("goBack", sender: self)
            
            }
        }
        
    }
    @IBAction func sendBtnPressed(sender: AnyObject) {
        
        var tags = [String]()
        var price = Float32()
        
        
        
        if tagsEdit.text != "" {
            
            tags = tagsEdit.text!.componentsSeparatedByString(",")
            
        } else {
            tags = myOffer.tags
        }
        
        if priceEdit.text != "" {
            
            price = Float32(priceEdit.text!)!
            
        } else {
            price = myOffer.price
        }
        
        
        let parameters:[String:AnyObject] = [
            
            "userId": myOffer.userID,
            "tags":tags,
            "images":myOffer.images,
            "location":[
                "lat":myOffer.latitude,
                "lon":myOffer.longitude
            ],
            "price": price
        ]
        
        Offers.updateOffer(myOffer as! Offer, parameters: parameters) { (success) -> Void in
            
            if success == true{
                
                self.switchView()
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}