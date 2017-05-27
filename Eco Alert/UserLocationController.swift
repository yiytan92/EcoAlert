//
//  UserLocationController.swift
//  Eco Alert
//
//  Created by Yi Yang  Tan  on 5/8/17.
//  Copyright © 2017 Yi Yang  Tan . All rights reserved.
//

import Foundation
import CoreLocation

class UserLocationController:NSObject,CLLocationManagerDelegate{
    
    static let sharedLocationController:UserLocationController = UserLocationController()
    static var currentLocation:CLLocation? = nil
    static let locationManager:CLLocationManager = CLLocationManager()
    
    class func startGPS(){
        locationManager.delegate = sharedLocationController
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
        locationManager.requestAlwaysAuthorization()
        
        let coordinateOne:CLLocationCoordinate2D  = CLLocationCoordinate2DMake( 40.741895, -73.989308)
        let coordinateTwo:CLLocationCoordinate2D  = CLLocationCoordinate2DMake( 40.728527, -74.208526)
        let locationsArray:NSArray = [coordinateOne, coordinateTwo]
        
        print(locationsArray[0])
        print(locationsArray[1])
    }
    
    class func stopGPS(){
        locationManager.stopUpdatingLocation()    }
    
    class func deviceLocation() -> CLLocationCoordinate2D{
        if(currentLocation != nil){
        return (currentLocation?.coordinate)!
        }
        else{
            return CLLocationCoordinate2DMake(34.020404,-118.286583)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         UserLocationController.currentLocation = locations[0]
    }
}
