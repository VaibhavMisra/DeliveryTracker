//
//  DeliveryDetailViewController.swift
//  DeliveryTracker
//
//  Created by Vaibhav Misra on 16/09/18.
//  Copyright © 2018 Vaibhav Misra. All rights reserved.
//

import UIKit
import MapKit

class DeliveryDetailViewController: UIViewController {
    
    var delivery: DeliveryDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UI
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        self.title = "Delivery Details"
        setupMapView()
    }
    
    private func setupMapView() {
        let mapView = MKMapView()

        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let loc = delivery!.location
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: loc.lat,
                                                      longitude:loc.lng)
        annotation.coordinate = centerCoordinate
        annotation.title = delivery?.location.address
        mapView.addAnnotation(annotation)
        
        let mapCenter = CLLocationCoordinate2DMake(loc.lat, loc.lng)
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(mapCenter, span)
        mapView.region = region
        
        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
    }
    
}
