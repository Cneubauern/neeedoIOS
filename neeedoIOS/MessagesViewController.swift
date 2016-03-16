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

class MessagesViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var messageInpunt: UITextField!
    
    var kbHeight: CGFloat!
    var nextY = CGFloat(20)

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInpunt.delegate = self
     
        
        self.placeLabel("hello there", sender: "recipient")
        self.placeLabel("hello there", sender: "sender")

    }

    func placeLabel(text:String, sender:String){
        
        
        let sendercolor = UIColor(red: 0.53, green: 0.745, blue: 0.69, alpha: 1.0)
        let recipientcolor = UIColor(red: 1.0, green: 0, blue: 0.43, alpha: 1)
        var bgColor = UIColor()
        
        let length = text.characters.count
        
        var  lines:Int = length/24
        
        if length % 24 != 0 {
            lines++
        }
        
        let height:CGFloat = CGFloat( lines * 20)
        
        let width = CGFloat(max(length * 6, 200))
        
        let recX = CGFloat(8)
        
        let sendX = CGFloat(self.view.bounds.width - (8+width))
        
        var xValue = CGFloat()
        
        switch sender{
            
        case "sender":
            xValue = sendX
            bgColor = sendercolor
            
        case "recipient":
            xValue = recX
            bgColor = recipientcolor
            
        default:
            
            print("there was an error")
            
        }
        
        let label = UILabel(frame: CGRectMake( xValue , CGFloat(nextY), width, height))
        
        label.backgroundColor = bgColor
        label.text = text
        
        nextY = (height + 2 * nextY)
        
        
        self.view.addSubview(label)
        
    }
    
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
    }
    
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.1, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) ->Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
}
