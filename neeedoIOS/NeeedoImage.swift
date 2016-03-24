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
    
    var imageName = String()
    var imageUrl = NSURL()
    var image = UIImage()
    var data = NSData()
    
    class func uploadImage(user:User, image:NeeedoImages, completionhandler:(String?)->Void){
        
        let credentialData = "\(user.userEmail):\(user.userPassword)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.upload(
            .POST,
            "\(staticUrl)/images",
            headers: headers,
            multipartFormData: { multipartFormData in
            
                    multipartFormData.appendBodyPart(fileURL: image.imageUrl, name: "image", fileName: image.imageName, mimeType: "image/.JPG")

            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        if let JSON = response.result.value{
                            if let image = JSON["image"] as? String{
                                completionhandler(image)
                            }
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
   
    class func getImageUrl(name:String)->NSURL{
        
        let URL = NSURL(string: "\(staticUrl)/images/\(name)")!
        
        return URL
        
    }
    
}

class NeeedoImage: NeeedoImages{
    
    init(imagename:String, url :NSURL) {
        super.init()
        self.imageUrl = url
        self.imageName = imagename
    }
}