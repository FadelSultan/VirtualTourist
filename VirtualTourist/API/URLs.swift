//
//  URLs.swift
//  VirtualTourist
//
//  Created by fadel sultan on 11/28/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import MapKit

struct URLs {
    static func getUrl(coordinate:CLLocationCoordinate2D , page:Int = 1) -> String {
        return "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=87e56e10eea73a99566a9ac1d0de7db6&extras=url_z&page=\(page)&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&format=json&nojsoncallback=1"
    }
}
