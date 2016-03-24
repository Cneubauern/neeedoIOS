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
    
    var location = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        
        self.map.delegate = self
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        zoom = Double(zoomSlider.value)
        
        relocate()
        
        self.getAnnotations()
        
    }
    
    // Get current User Location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        self.location = userLocation.coordinate
        
        relocate()
    }

        
    //Move and adjust MapView according to userlocation and zoomfactor

    func relocate(){
        
        print(zoom)
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(zoom, zoom)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(self.location, span)
        
        self.map.setRegion(region, animated: true)

        
    }
    
    // Assign custom View to Annotations
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
    
    // Place the annotations on th mapview
    // The annotations are created as custom classes to asign custompins to them
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
    
    
    // Get all offers and demands and create an annotation on the map.
    // Normally this would be relative to the current position or paginated,
    // but the current implementation of the API does not yet provide this functions
    
    func getAnnotations(){
        
        Offers.queryAllOffers { (offers) -> Void in
           
            for offer in offers! {
                
                if let title = offer["tags"] as? [String]{
                    
                    if let location = offer["location"] as? NSDictionary{
                    
                        if let lat = location["lat"] as? CLLocationDegrees{
                            print(lat)
                        
                            if let lon = location["lon"] as? CLLocationDegrees{
                            
                                print(lon)
                            
                                let newlocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                            
                                self.placeAnnotation(newlocation, title: title.joinWithSeparator(", "), subtitle: "", type: "offer")
                            }
                        }
                    }
                }
            }
        }
            
        Demands.queryAllDemands { (demands) -> Void in
            
            for demand in demands! {
                
                if let title = demand["mustTags"] as? [String]{
                    if let subtitle = demand["shouldTags"] as? [String]{
                        
                        if let location = demand["location"] as? NSDictionary{
                            
                            
                            if let lat = location["lat"] as? CLLocationDegrees{
                                print(lat)
                                
                                if let lon = location["lon"] as? CLLocationDegrees{
                                    
                                    print(lon)
                                    
                                    let newlocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                                    
                                    self.placeAnnotation(newlocation, title: title.joinWithSeparator(", "), subtitle: subtitle.joinWithSeparator(", "), type: "demand")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func zoom(sender: AnyObject) {
        
        zoom = Double(zoomSlider.value)
        
        zoomlabel.text = "\(zoom)"
        relocate()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
