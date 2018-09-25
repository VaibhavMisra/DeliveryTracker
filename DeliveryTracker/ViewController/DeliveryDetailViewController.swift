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
    var image: UIImage?
    
    let mapView = MKMapView()
    let imageView = UIImageView()
    let descLabel = UILabel()
    
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
        setupDetailView()
    }
    
    private func setupMapView() {
        
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
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(mapCenter, span)
        mapView.region = region
        
        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
    }
    
    private func setupDetailView() {
        if let image = image {
            imageView.image = image
        }
        descLabel.text = delivery?.description
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        containerView.addSubview(descLabel)
        view.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 5.0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 5.0).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.0).isActive = true
        
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5.0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        
        descLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10.0).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5.0).isActive = true
        
        
        descLabel.numberOfLines = 0
        imageView.contentMode = .scaleAspectFit
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}
