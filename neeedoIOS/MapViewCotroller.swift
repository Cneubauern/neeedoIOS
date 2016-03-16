//
//  MapViewCotroller.swift
//  neeedoIOS
//
//  Created by Christian Neubauer on 22.02.16.
//  Copyright © 2016 cneubauern. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var zoomSlider: UISlider!
    @IBOutlet var zoomlabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    var zoom:CLLocationDegrees = CLLocationDegrees()
    
    var latitude:CLLocationDegrees = 52.496877
    var longitude:CLLocationDegrees = 13.509821
    
    
    override func viewDidLoad() {
        
        self.map.delegate = self
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        zoom = Double(zoomSlider.value)
        
        relocate(latitude, longitude: longitude)
        
        self.getAnnotations()
        
    }
    
    func action(gestureRecognizer: UIGestureRecognizer){
        
        print("gesture recognized")
        
        let touchPoint = gestureRecognizer.locationInView(self.map)
        
        let newCoordinate:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        placeAnnotation(newCoordinate, title: "You Touched Here", subtitle: "Why?", type: "normal" )
        
    }
    
    func relocate(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        
        print(zoom)
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(zoom, zoom)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)

        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
         latitude = userLocation.coordinate.latitude
        
        NSUserDefaults.standardUserDefaults().setObject(latitude, forKey: "UserLat")
        
         longitude = userLocation.coordinate.longitude
        
        NSUserDefaults.standardUserDefaults().setObject(longitude, forKey: "UserLon")
        
        relocate(latitude, longitude: longitude)
    
        
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
    
    func placeAnnotation(location:CLLocationCoordinate2D, title: String, subtitle:String, type:String){
        
        switch type{
            
            case "offer":
                let annotation = offerPin(coordinate: location, title: title, subtitle: subtitle)
                map.addAnnotation(annotation)

            case "demand":
                let annotation = demandPin(coordinate: location, title: title, subtitle: subtitle)
                map.addAnnotation(annotation)

            default:
                let annotation = MKPointAnnotation()
                annotation.title = title
                annotation.subtitle = subtitle
                annotation.coordinate = location
                map.addAnnotation(annotation)
        }
    }
    
    func getAnnotations(){
        
        Offers.queryAllOffers { (offers) -> Void in
           
            for offer in offers! {
                
                if let location = offer["location"] as? NSDictionary{
                    
                    
                    if let lat = location["lat"] as? CLLocationDegrees{
                        print(lat)
                        
                        if let lon = location["lon"] as? CLLocationDegrees{
                            
                            print(lon)
                            
                            let newlocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                            
                            self.placeAnnotation(newlocation, title: "Offer", subtitle: "Something", type: "offer")
                            
                        }
                    }
                }
            }
        }
            
        Demands.queryAllDemands { (demands) -> Void in
            
            for demand in demands! {
                
                if let location = demand["location"] as? NSDictionary{
                    
                    
                    if let lat = location["lat"] as? CLLocationDegrees{
                        print(lat)
                        
                        if let lon = location["lon"] as? CLLocationDegrees{
                            
                            print(lon)
                            
                            let newlocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                            
                            self.placeAnnotation(newlocation, title: "Offer", subtitle: "Something", type: "demand")
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func showProfile(sender: AnyObject) {
        
        self.performSegueWithIdentifier("profile", sender: self)
    
    }
    
    @IBAction func zoom(sender: AnyObject) {
        
        zoom = Double(zoomSlider.value)
        
        
        zoomlabel.text = "\(zoom)"
        relocate(latitude, longitude: longitude)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
