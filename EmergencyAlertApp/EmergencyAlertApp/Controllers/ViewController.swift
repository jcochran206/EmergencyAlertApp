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
    
    private var documentRef: DocumentReference!
    
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
        
        saveEventToFirebase()
        
        
    }
    
    private func addEventToMap(_ event: Event) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: event.lat, longitude: event.long)
        annotation.title = "Hazard Event"
        annotation.subtitle = event.reportedDate.formatToString()
        self.mapView.addAnnotation(annotation)
    }
    
    private func saveEventToFirebase() {
        
        guard let location = self.locationManager.location else{
            return
        }
        
        var event = Event(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        
        self.documentRef = self.db.collection("Alert-Hazard-Events").addDocument(data: event.toDictionary()) {
            [weak self] error in
            
            if let error = error {
                print(error)
            } else {
                event.documentID = self?.documentRef.documentID
                self?.addEventToMap(event)
            }
        }
        
    }

    private func setupUI() {
        self.eventBtn.layer.cornerRadius = 8.0
        self.eventBtn.layer.masksToBounds = true
    }
}
