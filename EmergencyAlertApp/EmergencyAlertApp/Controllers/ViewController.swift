//
//  ViewController.swift
//  EmergencyAlertApp
//
//  Created by Jonathan Cochran on 3/31/19.
//  Copyright © 2019 Jonathan Cochran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventBtn: UIButton!
    
    private lazy var db: Firestore = {
        let firestoreDB = Firestore.firestore()
        return firestoreDB
    }()
    
    private lazy var locationManager: CLLocationManager = {
       
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.requestAlwaysAuthorization()
        return manager
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        setupUI()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, latitudinalMeters: 100.0, longitudinalMeters: 100.0)
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func addEventBtnPressed() {
        
        guard let location = self.locationManager.location else{
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.title = "something"
        annotation.subtitle = "subtitle"
        annotation.coordinate = location.coordinate
        
        self.mapView.addAnnotation(annotation)
        
        saveEventToFirebase()
        
    }
    
    private func saveEventToFirebase() {
        self.db.collection("EventActioned").addDocument(data: ["lat:" : "47.258728", "long:" : "-122.465973"]){ error in if let error = error {
            print(error)
        }else {
            print("saved")
            }
        }
    }

    private func setupUI() {
        self.eventBtn.layer.cornerRadius = 8.0
        self.eventBtn.layer.masksToBounds = true
    }
}
