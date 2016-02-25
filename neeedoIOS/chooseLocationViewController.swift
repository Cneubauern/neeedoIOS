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

class chooseLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        //fill in the blank
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func placeAnnotation(location:CLLocationCoordinate2D, title: String, subtitle:String ){
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        annotation.title = title
        
        annotation.subtitle = subtitle
        
        mapView.addAnnotation(annotation)
        
    }

}