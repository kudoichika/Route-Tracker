//
//  DataViewController.swift
//  Route-Tracking
//
//  Created by Kudo on 9/16/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DataViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var geodata : EntryData!
    var buttons : Array<UIButton>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = [shareButton, backButton]
        for button in buttons {
            button.layer.cornerRadius = button.layer.frame.height / 2
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.gray.cgColor
        }
        
        navBar.topItem?.title = geodata.timeToString()
        
        backButton.layer.zPosition = navBar.layer.zPosition + 1
        
        mapView.delegate = self
        mapView.mapType = MKMapType(rawValue: 0)!
        
        /*let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: geodata.latitude, longitude: geodata.longitude)
        mapView.addAnnotation(annotation)
        
        let center = CLLocationCoordinate2D(latitude: geodata.latitude, longitude: geodata.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)*/

        shareButton.addTarget(self, action: #selector(shareData), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func shareData() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
