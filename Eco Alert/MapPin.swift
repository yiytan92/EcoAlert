//
//  MapPin.swift
//  Eco Alert
//
//  Created by Yi Yang  Tan  on 4/17/17.
//  Copyright © 2017 Yi Yang  Tan . All rights reserved.
//

import MapKit

class MapPin:NSObject, MKAnnotation{
    
    var title: String?
    var subtitle:String?
    var coordinate:CLLocationCoordinate2D
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
