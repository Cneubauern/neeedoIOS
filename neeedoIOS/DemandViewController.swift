//
//  DemandViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 16.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MapKit

class DemandViewController:  UIViewController{
    @IBOutlet var mustTagsLabel: UILabel!
    @IBOutlet var shouldTagsLabel: UILabel!
    @IBOutlet var minPriceLabel: UILabel!
    @IBOutlet var maxPriceLabel: UILabel!
    @IBOutlet var mustTagsEdit: UITextField!
    @IBOutlet var shouldTagsEdit: UITextField!
    @IBOutlet var minPriceEdit: UITextField!
    @IBOutlet var maxPriceEdit: UITextField!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var locationMap: MKMapView!
    
    @IBOutlet var sendBtn: UIButton!
    var myDemand = Demands()
    
    var edit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mustTagsEdit.hidden = true
        shouldTagsEdit.hidden = true
        minPriceEdit.hidden = true
        maxPriceEdit.hidden = true
        sendBtn.hidden = true
        
        mustTagsLabel.text = myDemand.mustTags.joinWithSeparator(",")
        shouldTagsLabel.text = myDemand.shouldTags.joinWithSeparator(",")
        minPriceLabel.text = "\(myDemand.minPrice)"
        maxPriceLabel.text = "\(myDemand.maxPrice)"
        userLabel.text = myDemand.userName
    }
    
    @IBAction func editDemand(sender: AnyObject) {
        
        self.switchView()
     
    }
    @IBAction func sendEdit(sender: AnyObject) {
        
        var mustTags = [String]()
        var shouldTags = [String]()
        var distance = Float32()
        var min = Float32()
        var max = Float32()

        
        
        if mustTagsEdit.text != "" {
        
            mustTags = mustTagsEdit.text!.componentsSeparatedByString(",")
            
        } else {
            mustTags = myDemand.mustTags
        }
        
        if shouldTagsEdit.text != "" {
            
            shouldTags = shouldTagsEdit.text!.componentsSeparatedByString(",")
            
        } else {
            shouldTags = myDemand.shouldTags
        }
        
        if minPriceEdit.text != "" {
            
            min = Float32(minPriceEdit.text!)!
            
        } else {
            min = myDemand.minPrice
        }
        
        if maxPriceEdit.text != "" {
            
            max = Float32(minPriceEdit.text!)!
            
        } else {
            max = myDemand.maxPrice
        }
        
        
        
        let parameters:[String:AnyObject] = [
            
            "userId": myDemand.userID,
            "mustTags":mustTags,
            "shouldTags":shouldTags,
            "location":[
                "lat":myDemand.latitude,
                "lon":myDemand.longitude
            ],
            "distance":myDemand.distance,
            "price":[
                "min":min,
                "max":max
            ]
        ]
        
        Demands.updateDemand(myDemand, parameters: parameters) { (success) -> Void in
            
            if success == true{
                
                self.switchView()
                
            }
        }
        
    }
    
    func switchView(){
      
        if edit == false{
            
            mustTagsEdit.hidden = false
            shouldTagsEdit.hidden = false
            minPriceEdit.hidden = false
            maxPriceEdit.hidden = false
            sendBtn.hidden = false
            
            mustTagsLabel.hidden = true
            shouldTagsLabel.hidden = true
            minPriceLabel.hidden = true
            maxPriceLabel.hidden = true
            
            mustTagsEdit.placeholder = myDemand.mustTags.joinWithSeparator(",")
            shouldTagsEdit.placeholder = myDemand.shouldTags.joinWithSeparator(",")
            minPriceEdit.placeholder = "\(myDemand.minPrice)"
            maxPriceEdit.placeholder = "\(myDemand.maxPrice)"
            
            edit = true
            
        } else {
            
            mustTagsEdit.hidden = true
            shouldTagsEdit.hidden = true
            minPriceEdit.hidden = true
            maxPriceEdit.hidden = true
            sendBtn.hidden = true
            
            mustTagsLabel.hidden = false
            shouldTagsLabel.hidden = false
            minPriceLabel.hidden = false
            maxPriceLabel.hidden = false
            
            mustTagsLabel.text = myDemand.mustTags.joinWithSeparator(",")
            shouldTagsLabel.text = myDemand.shouldTags.joinWithSeparator(",")
            minPriceLabel.text = "\(myDemand.minPrice)"
            maxPriceLabel.text = "\(myDemand.maxPrice)"
            userLabel.text = myDemand.userName
            
            edit = true
        }
    }
    
    @IBAction func DeleteDemand(sender: AnyObject) {
        
        Demands.deleteDemand(myDemand) { (success) -> Void in
            if success == true{
                self.performSegueWithIdentifier("goBack", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}