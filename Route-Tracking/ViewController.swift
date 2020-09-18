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
    @IBOutlet weak var snapButton: UIButton!
    var buttons : Array<UIButton>!

    var timer : Timer?
    var recordDoc : DocumentReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        K.Fire.uid = Auth.auth().currentUser!.uid
        
        buttons = [optionButton, dataButton, routeButton, locButton, snapButton]
        for button in buttons {
            button.layer.cornerRadius = button.layer.frame.height / 2
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.gray.cgColor
        }
        
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
        
        routeButton.addTarget(self, action: #selector(toggleRec), for: .touchUpInside)
        locButton.addTarget(self, action: #selector(centerLoc), for: .touchUpInside)
        snapButton.addTarget(self, action: #selector(storeLoc), for: .touchUpInside)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last as CLLocation?
    }
    
    @objc func centerLoc() {
        /*let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        mapCamera.pitch = 45
        mapCamera.altitude = 500
        mapCamera.heading = 45
        mapView.camera = mapCamera*/
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: center, span: span)
        switch (mapView.mapType) {
            case .hybrid:
                mapView.mapType = .satellite
                break
            case .standard:
                mapView.mapType = .hybrid
                break
            default:
                mapView.mapType = .standard
                break
        }
        mapView.setRegion(region, animated: true)
    }
    
    @objc func storeLoc() {
        let data = GeoData(lat: location!.coordinate.latitude, long: location!.coordinate.longitude)
        data.postData(id: K.Fire.uid, col: K.Fire.locData, subcol: K.Fire.pointsData)
    }
    
    @objc func toggleRec() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
            //ad data (end time + type)
            recordDoc = nil
            routeButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(1),
            target: self, selector: #selector(record),
            userInfo: nil, repeats: true)
            let db = Firestore.firestore()
            let entries = db.collection(K.Fire.locData).document(K.Fire.uid)
            recordDoc = entries.collection(K.Fire.entryData).document()
            //add data (start time + collection)
            routeButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc func record() {
        //create collection in toggleRec()
        //add value every time called with timestamp
        
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

