//
//  NeeedoImage.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 13.03.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class NeeedoImages{
    
    var imagename = String()
    var image = UIImage()
    
    class func uploadImage(image:NeeedoImage, completionhandler:()->Void){
        
        
        
        
    }
   
    func getImageUrl(image:NeeedoImage)->NSURL{
        
        let imageUrl = NSURL(string: "\(staticUrl)/images/\(imagename)")!
        
        return imageUrl
        
    }
    
}

class NeeedoImage: NeeedoImages{
    
    init(imagename:String, image:UIImage) {
        super.init()
        self.image = image
        self.imagename = imagename
    }
}