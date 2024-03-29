//
//  chooseLocationViewController.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 25.02.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class chooseLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
  
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var addressInput: UITextField!
    
    var identifier = String()
    
    var location = CLLocationCoordinate2D()
    
    let geocoder = CLGeocoder()

    var uilpgr = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        //fill in the blank
    
        self.mapView.delegate = self
        
        addressInput.delegate = self
        
        print(location)
        relocate(location)
        placeAnnotation(location)
        
        uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocationViewController.action(_:)))
        
        uilpgr.minimumPressDuration = 1
        
        mapView.addGestureRecognizer(uilpgr)
        
        navigationController?.navigationBarHidden = false

    }
    
    override func viewDidDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
    func action(gestureRecognizer: UIGestureRecognizer){
        
        print("gesture recognized")
        
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
        
        let newCoordinate:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        placeAnnotation(newCoordinate)
        
    }

    
    @IBAction func findLocation(sender: AnyObject) {
        
        let address = addressInput.text! as String
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                self.location = coordinates
                
                self.relocate(coordinates)
                
                self.placeAnnotation(coordinates)
            }
        })
    }

    func removeAnnotations(){
    
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)

    }
    
    
    func relocate(coordinate:CLLocationCoordinate2D){
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        
        let location:CLLocationCoordinate2D = coordinate
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if identifier == "chooseLocationOffer"{
            
            let covc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreateOffer") as! CreateOfferViewController
            
            covc.chosenlocation = location
            
        }else if identifier == "chooseLocationDemand" {
            
            let cdvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreateDemand") as! CreateDemandViewController
            
            cdvc.chosenlocation = location
            
        }
    }
    
    func placeAnnotation(location:CLLocationCoordinate2D){
        
        self.removeAnnotations()
        
        var type = String()
        let title = addressInput.text! as String
        let subtitle = "lat:\(location.latitude), lon:\(location.longitude)"
        
        if identifier == "chooseLocationDemand"{
        
            type = "demand"

            
        }else if identifier == "chooseLocationOffer" {
            
            type = "offer"

        }

        switch type{
            
        case "offer":
            let annotation = offerPin(coordinate: location, title: title, subtitle: subtitle)
            mapView.addAnnotation(annotation)
            
        case "demand":
            let annotation = demandPin(coordinate: location, title: title, subtitle: subtitle)
            mapView.addAnnotation(annotation)
            
        default:
            let annotation = MKPointAnnotation()
            annotation.title = title
            annotation.subtitle = subtitle
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil
        {
            if annotation.isKindOfClass(offerPin){
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView!.canShowCallout = true
                annotationView!.image = UIImage(named: "offerPin")
            }else if annotation.isKindOfClass(demandPin){
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView!.canShowCallout = true
                annotationView!.image = UIImage(named: "demandPin")
            } else if annotation.isKindOfClass(MKUserLocation){
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView!.canShowCallout = true
                annotationView!.image = UIImage(named: "userPin")
            }
            
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) ->Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}