//
//  Models.swift
//  Route-Tracking
//
//  Created by Kudo on 9/16/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseFirestore

class GeoData {
    var latitude : CLLocationDegrees!
    var longitude : CLLocationDegrees!
    var timestamp : NSDate!
    init(loc : CLLocation) {
        latitude = loc.coordinate.latitude
        longitude = loc.coordinate.longitude
        timestamp = NSDate()
    }
    init (dict : [String : Any]) {
        let geo = dict["geo"] as! GeoPoint
        let time = dict["time"] as! TimeInterval
        latitude = geo.latitude
        longitude = geo.longitude
        timestamp = NSDate(timeIntervalSince1970: time)
    }
    func toDict() -> [String : Any] {
        return [
            "geo" : GeoPoint.init(latitude : latitude, longitude : longitude),
            "time" : timestamp.timeIntervalSince1970
        ]
    }
    /*func postData(id : String, col : String, subcol : String) {
        let db = Firestore.firestore()
        let doc = db.collection(col).document(id)
        doc.collection(subcol).addDocument(data : toDict()) { (error) in
            if error != nil {
                print("Error storing geolocation")
            } else {
                print("Successful stored location")
            }
        }
    }*/
    func timestampToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        return formatter.string(from: timestamp! as Date)
    }
}

class EntryData {
    var starttime : NSDate!
    var endtime : NSDate!
    var docSnap : DocumentSnapshot!
    var type : String!
    init(snap : DocumentSnapshot) {
        docSnap = snap
        let ref = docSnap.data()
        starttime = NSDate(timeIntervalSince1970: (ref!["starttime"] as! TimeInterval))
        if ref!["endtime"] != nil {
            endtime = NSDate(timeIntervalSince1970: (ref!["endtime"] as! TimeInterval))
        } else {
            endtime = nil
        }
        //type = (ref!["datatype"] as! String)
    }
    func timeToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        return formatter.string(from: starttime! as Date)
            + "-"
            + formatter.string(from: endtime! as Date)
    }
}
