//
//  Locations.swift
//  VirtualTourist
//
//  Created by fadel sultan on 11/28/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import MapKit

// get data from flickr api
struct Locations:Codable {
    var photos:Photos?
    var stat:String?
    
    static func get(url:String , compilcationHandler:@escaping(Swift.Result<[Photo] , Error>)->Void) {
        API.webService(url: url) { (result) in
            switch result {
            case .success(let data):
                do {
                    compilcationHandler(.success(try JSONDecoder().decode(Locations.self, from: data).photos!.photo))
                }catch let error {
                    compilcationHandler(.failure(error))
                }
            case .failure(let error):
                compilcationHandler(.failure(error))
            }
        }
    }
}

struct Photos:Codable {
    var page:Int?
    var pages:Int?
    var perpage:Int?
    var total:String?
    var photo = [Photo]()
}

struct Photo:Codable {
    var id:String?
    var owner:String?
    var secret:String?
    var server:String?
    var farm:Int?
    var title:String?
    var ispublic:Int?
    var isfriend:Int?
    var isfamily:Int?
    var url_z:String?
    var height_z:Int?
    var width_z:Int?
}


// get data from local database
struct modelLocation {
    
    static var coordinates = [modelLocation]()
    
    var id:Int64
    var coordinate:CLLocationCoordinate2D
    
}
