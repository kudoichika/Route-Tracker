//
//  ViewController.swift
//  Route-Tracking
//
//  Created by Kudo on 9/13/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var location : CLLocation!
    
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var locButton: UIButton!
    var buttons : Array<UIButton>!
    
    var id : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = [dataButton, routeButton, locButton]
        for button in buttons {
            button.layer.cornerRadius = button.layer.frame.height / 2
        }
        
        let user = Auth.auth().currentUser
        id = user!.uid
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
               locationManager.requestAlwaysAuthorization()
               locationManager.requestWhenInUseAuthorization()
           }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        routeButton.addTarget(self, action: #selector(storeLoc), for: .touchUpInside)
        locButton.addTarget(self, action: #selector(centerLoc), for: .touchUpInside)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last as CLLocation?
    }
    
    @objc func centerLoc() {
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func storeLoc() {
        
        let geo = GeoPoint.init(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let time = NSDate().timeIntervalSince1970
        
        /*
         Decoding
         let myTimeInterval = TimeInterval(timestamp)
         let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
         */
        
        let db = Firestore.firestore()
        let doc = db.collection("location").document(id!)
        doc.collection("points").addDocument(data: ["geo": geo, "time": time]) {(error) in
            if error != nil {
                print("Error storing geolocation")
            } else {
                print("Successfully stored location")
            }
        }
    }

}

