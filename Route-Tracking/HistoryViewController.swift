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

extension UIView {
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, height : CGFloat?, width : CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: 5).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: 5).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -5).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -5).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height!).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width!).isActive = true
        }
    }
}

class CustomCell: UITableViewCell {
    var object : GeoData? {
        didSet {
            cellButton.setTitle(object!.timestampToString(), for: .normal)
        }
    }
    var cellButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.blue, for: .highlighted)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellButton)
        cellButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 75, width: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var items : Array<GeoData>! = []
    let cellId : String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellId)
        getDataAndParse()
    }
    
    func getDataAndParse() {
        let id = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        let subdoc = db.collection("location").document(id).collection("points")
        let query = subdoc.order(by: "time", descending: true)
        query.getDocuments { (snap, error) in
            if error != nil {
                print("Error getting Query Documents")
            } else {
                //print("Got", snap!.documents.count, "pieces of data")
                for docsnap in snap!.documents {
                    let dict = docsnap.data()
                    self.items.append(GeoData(dict : dict))
                }
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomCell
        cell.object = items[indexPath.row]
        cell.cellButton.tag = indexPath.row
        cell.cellButton.addTarget(self, action: #selector(cellTapped), for : .touchUpInside)
        return cell
    }
    
    @objc func cellTapped(sender : Any) {
        let index = (sender as! UIButton).tag
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier : "DataView") as? DataViewController
        nextVC!.geodata = items[index]
        self.view.window?.rootViewController = nextVC
        self.view.window?.makeKeyAndVisible()
    }

}




