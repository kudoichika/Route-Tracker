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
    
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var locButton: UIButton!
    var buttons : Array<UIButton>!
    
    var id : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = [optionButton, dataButton, routeButton, locButton]
        for button in buttons {
            button.layer.cornerRadius = button.layer.frame.height / 2
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.gray.cgColor
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
        let data = GeoData(lat: location!.coordinate.latitude, long: location!.coordinate.longitude)
        data.postData(id: id!, col: "location", subcol: "points")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Already Logged Out")
            }
        }
    }

}

