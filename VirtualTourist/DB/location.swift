//
//  location.swift
//  VirtualTourist
//
//  Created by fadel sultan on 12/2/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import SQLite
import MapKit



extension DB {
    struct location {
        //        Variables daabase
        private static let coordinate = Table("coordinate")
        private static let id = Expression<Int64>("id")
        private static let lat = Expression<Double>("lat")
        private static let long = Expression<Double>("long")
        
        private static func createTbl(compilation:@escaping(Swift.Result<Connection , Error>)-> Void ){
            guard let db = DB.createConnection() else {
                compilation(.failure(errorDB.connection))
                return
            }
            do {
                try db.run(DB.location.coordinate.create(ifNotExists: true) { t in
                    t.column(DB.location.id, primaryKey: true)
                    t.column(DB.location.lat, unique: true)
                    t.column(DB.location.long, unique: true)
                })
                compilation(.success(db))
            }catch let error {
                compilation(.failure(error))
            }
            
        }
        
        static func insert(location:CLLocationCoordinate2D , compilation:@escaping(Swift.Result<Int64 , Error>) -> Void) {
            
            DB.location.createTbl { (result) in
                switch result {
                case .success(let db):
                    do {
                        try db.run(DB.location.coordinate.insert(DB.location.lat <- Double(location.latitude) , DB.location.long <- Double(location.longitude)))
                        let query = DB.location.coordinate.select(DB.location.id).order(id.desc).limit(1)
                        for row in try db.prepare(query) {
                            compilation(.success(row[id]))
                        }
                    } catch let error {
                        compilation(.failure(error))
                    }
                case .failure(let error):
                    compilation(.failure(error))
                }
            }
        }
        
        static func locations(compilation:@escaping(Swift.Result< [modelLocation] , Error>)->Void) {
            DB.location.createTbl { (result) in
                switch result {
                case .success(let db):
                    do {
                        var locations = [modelLocation]()
                        for row in try db.prepare(DB.location.coordinate) {
                            let coordinate = CLLocationCoordinate2D(latitude: row[lat], longitude: row[long])
                            let m = modelLocation(id: row[id], coordinate: coordinate)
                            locations.append(m)
                        }
                        compilation(.success(locations))
                    } catch let error {
                        compilation(.failure(error))
                    }
                case .failure(let error):
                    compilation(.failure(error))
                }
            }
        }
    }
}
