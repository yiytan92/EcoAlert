//
//  TableViewController.swift
//  Eco Alert
//
//  Created by Yi Yang  Tan  on 5/8/17.
//  Copyright © 2017 Yi Yang  Tan . All rights reserved.
//

import Foundation
import UIKit

class Cell:UITableViewCell{
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var alertDescription: UILabel!
    
    @IBOutlet weak var alertLat: UILabel!
    
    @IBOutlet weak var alertLong: UILabel!
}

class TableViewController: UITableViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: LocationsController.LOCATION_ADDED_NOTIFICATION, object: nil, queue: nil){notification in
            self.tableView.reloadData()
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationsController.sharedLocations().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let cellIdentifier = "Cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)as!Cell

        
        let locationsArray:Array = LocationsController.sharedLocations()
        let location:MapPin = locationsArray[indexPath.row] as! MapPin
        
        cell.locationName?.text = location.title
        cell.alertDescription?.text=location.subtitle
        cell.alertLat?.text=String(location.coordinate.latitude)
        cell.alertLong?.text=String(location.coordinate.longitude)
        
        
        return cell
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}


