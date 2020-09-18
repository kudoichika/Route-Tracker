//
//  Constants.swift
//  Route-Tracking
//
//  Created by Kudo on 9/18/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct K {
    struct Fire {
        static var uid = ""
        static let userData = "userdata"
        static let locData = "location"
        static let entryData = "entries"
        static let pointsData = "points"
    }
    struct View {
        static let mainView = "MainView"
        static let homeView = "HomeView"
        static let dataView = "DataView"
    }
}
