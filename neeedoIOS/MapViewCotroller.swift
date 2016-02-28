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
    
    var locationManager = CLLocationManager()
    
    var zoom:Double = Double()
    
    override func viewDidLoad() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")

        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
       
        
        
    }
    
    func action(gestureRecognizer: UIGestureRecognizer){
        
        print("gesture recognized")
        
        let touchPoint = gestureRecognizer.locationInView(self.map)
        
        let newCoordinate:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        placeAnnotation(newCoordinate, title: "You Touched Here", subtitle: "Why?")
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        NSUserDefaults.standardUserDefaults().setObject(latitude, forKey: "UserLat")
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        NSUserDefaults.standardUserDefaults().setObject(longitude, forKey: "UserLon")
        
        let latDelta:CLLocationDegrees = zoom
        let lonDelta:CLLocationDegrees = zoom
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func placeAnnotation(location:CLLocationCoordinate2D, title: String, subtitle:String ){
        
        let annotation = MKPointAnnotation()

        annotation.coordinate = location
        
        annotation.title = title
        
        annotation.subtitle = subtitle
        
        map.addAnnotation(annotation)
        
    }
    
    @IBAction func showProfile(sender: AnyObject) {
        self.performSegueWithIdentifier("profile", sender: self)
    }
    
    func getAllNearItems(){
        
    }
    @IBAction func zoom(sender: AnyObject) {
        
        resizeWindow(zoomSlider.value)
        
    }
    
    func resizeWindow(zoomFactor:Float32){
        
        zoom = Double(zoomFactor)
    }
    
    
    
}
