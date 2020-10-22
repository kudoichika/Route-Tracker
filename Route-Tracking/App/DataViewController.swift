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
    
    class Pin: NSObject, MKAnnotation {
        var identifier = ""
        var title: String?
        var coordinate: CLLocationCoordinate2D
        init(pt: GeoData) {
            title = pt.timestampToString()
            coordinate = CLLocationCoordinate2DMake(pt.latitude, pt.longitude)
        }
        func getMapItem() -> MKMapItem {
            return MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        }
    }
    
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
        
        addRoutes()
        // Do any additional setup after loading the view.
    }
    
    func addRoutes() {
        let list = geodata.docSnap.reference.collection(K.Fire.pointsData)
        //let query = list.order(by: "time", descending: true)
        var maxL : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -90, longitude: -180)
        var minL : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 90, longitude: 80)
        list.getDocuments { (snap, error) in
            if error != nil {
                print("Error getting Route Information")
            } else {
                for docsnap in snap!.documents {
                    let point = GeoData(dict: docsnap.data())
                    let pin = Pin(pt: point)
                    maxL.latitude = max(maxL.latitude, pin.coordinate.latitude)
                    maxL.longitude = max(maxL.longitude, pin.coordinate.longitude)
                    minL.latitude = min(minL.latitude, pin.coordinate.latitude)
                    minL.longitude = min(minL.latitude, pin.coordinate.longitude)
                    self.mapView.addAnnotation(pin)
                }
            }
        }
        let center = CLLocationCoordinate2D(latitude: (minL.latitude + maxL.latitude)/2, longitude: (minL.longitude + maxL.longitude)/2)
        //calculate distance to edges for span
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func shareData() {
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
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
