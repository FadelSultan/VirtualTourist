//
//  Ex+Pin.swift
//  VirtualTourist
//
//  Created by fadel sultan on 12/3/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import MapKit

extension Pin {
    var coordinate:CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func validation(coordinate:CLLocationCoordinate2D) -> Bool {
        return (latitude == coordinate.longitude && longitude == coordinate.longitude)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
