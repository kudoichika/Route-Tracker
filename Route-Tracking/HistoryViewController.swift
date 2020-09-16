//
//  HistoryViewController.swift
//  Route-Tracking
//
//  Created by Kudo on 9/14/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

struct CellItem {
    let text : String!
    init(data : GeoData) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        text = formatter.string(from: data.timestamp! as Date)
    }
}

class CustomCell : UITableViewCell {
}

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var items : Array<CellItem>! = []
    let cellId : String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        getDataAndParse()
    }
    
    func getDataAndParse() {
        let id = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        let subdoc = db.collection("location").document(id).collection("points")
        let query = subdoc.order(by: "time")
        query.getDocuments { (snap, error) in
            if error != nil {
                print("Error getting Query Documents")
            } else {
                for docsnap in snap!.documents {
                    let dict = docsnap.data()
                    let data = GeoData(dict : dict)
                    self.items.append(CellItem(data : data))
                    print(self.items.count)
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].text!
        return cell
    }

}
