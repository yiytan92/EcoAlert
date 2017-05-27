//
//  LocationsController.swift
//  Eco Alert
//
//  Created by Yi Yang  Tan  on 5/8/17.
//  Copyright © 2017 Yi Yang  Tan . All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import CoreLocation
import CoreData

class LocationsController:NSObject{
    
    public static let LOCATION_ADDED_NOTIFICATION = NSNotification.Name("LOCATION_ADDED")
    
    static let alertPinClassName:String = String(describing:AlertModel.self)
    static var locationsArray:Array = Array<MapPin>()
    
    class func sharedLocations() -> Array<Any>{
        return locationsArray
    }
    
    class func addLocation( building:MapPin ){


        LocationsController.locationsArray.insert(building,at:0)
        //When we add a new Alert & location, also add it as an entity in CoreData
        let newEntity:AlertModel = NSEntityDescription.insertNewObject(forEntityName: alertPinClassName, into: DatabaseController.getContext()) as! AlertModel
        
        newEntity.pinName = building.title
        newEntity.pinDescription = building.subtitle
        newEntity.pinLatitude = building.coordinate.latitude
        newEntity.pinLongitude = building.coordinate.longitude

        
        NotificationCenter.default.post(name:LOCATION_ADDED_NOTIFICATION, object: building)
    }
    
    class func loadLocations(){
        
        Alamofire.request("https://manager.swiftengine.net/modules/servers/ispcfg3/elfinder.connector.php?ftp=eyJob3N0IjoiZWNvYWxlcnQuc2l0ZS5zd2lmdGVuZ2luZS5uZXQiLCJ1c2VyIjoiZWNvYWxlcnRhZG1pbiIsInBhc3MiOiI2aDBNNjdLcWZ3In0%3D&cmd=file&target=f1_YWxlcnRNZXNzYWdlcy5zc3A").responseString{response in
            do{
                
                let jsonString = response.result.value!
                let jsonData = jsonString.data(using: .utf8)!
                let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as! NSArray
                
                for(_,jsonObject) in jsonArray.enumerated(){
                    let currentBuilding:Dictionary = jsonObject as! Dictionary<String, AnyObject>
                    
                    let NAME_KEY = "name"
                    let LOCATION_KEY = "location"
                    let DESCRIPTION_KEY = "description"
                    let LATITUDE_KEY = "latitude"
                    let LONGITUDE_KEY = "longitude"
                    
                    let nameString:String = currentBuilding[NAME_KEY] as! String
                    let descriptionString:String = currentBuilding[DESCRIPTION_KEY] as! String
                    
                    let locationDictionary:Dictionary = currentBuilding[LOCATION_KEY] as! Dictionary<String,Double>
                    let latitude:Double = locationDictionary[LATITUDE_KEY]! as Double
                    let longitude:Double = locationDictionary[LONGITUDE_KEY]! as Double
                    
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude)
                    
                    let currentMapPin:MapPin = MapPin(title: nameString, subtitle: descriptionString, coordinate: location)
                    
//                    self.mapView.addAnnotation(currentMapPin)
                    LocationsController.addLocation(building: currentMapPin)
                }
            }
            catch{
                print("error")
            }
        }

    }
    
}
