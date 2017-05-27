//
//  ViewController.swift
//  Eco Alert
//
//  Created by Yi Yang  Tan  on 4/17/17.
//  Copyright © 2017 Yi Yang  Tan . All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Request location access permission
//        _locationManager!.requestWhenInUseAuthorization()
        
        // Start observing location
//        _locationManager!.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        //set initial zone at USC
        let initialLocation = CLLocation(latitude: 34.020404, longitude: -118.286583)
      centerMapOnLocation(location: initialLocation)
        
        
        //NotificationCenter observer is used to inform us when location is added and synchronously informs tableviewcontroller. Once a map pin is loaded from swiftengine site, add the pin to mapview
        NotificationCenter.default.addObserver(forName: LocationsController.LOCATION_ADDED_NOTIFICATION, object: nil, queue: nil){notification in
            let newLocationPin:MapPin = notification.object as! MapPin
            
            self.mapView.addAnnotation(newLocationPin)
        }
        
        let workQueue = DispatchQueue(label:"com.itp.myapp.backgroundQueue",attributes:[])
        
        
        workQueue.async{
            
            //background task exception handler
            var bTask:UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
            
            //bTask = UIApplication.shared.beginBackgroundTaskWithExpirationHandler{ () -> Void in
            
            //   UIApplication.sharedApplication().endBackgroundTask(bTask)
            // bTask = UIBackgroundTaskInvalid
            
            //}
            
            bTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(bTask)
                bTask=UIBackgroundTaskInvalid
            })
        
            DispatchQueue.main.sync{
        let locationsArray:Array = LocationsController.sharedLocations()
        
        for (_,currentObject) in locationsArray.enumerated(){
            let currentPin:MapPin = currentObject as! MapPin
            self.mapView.addAnnotation(currentPin)
        }
            }
        }
        
        
        //moved this to AppDelegate for immediate loading without relying on views
//        LocationsController.loadLocations()
        
        
    }
    
    let regionRadius: CLLocationDistance = 3000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

