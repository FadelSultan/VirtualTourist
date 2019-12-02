//
//  photos.swift
//  VirtualTourist
//
//  Created by fadel sultan on 12/2/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import SQLite

extension DB {
    struct images {
        
        //        Variables
        private static let photos = Table("photos")
        private static let id = Expression<Int64>("id")
        private static let idLocation = Expression<Int64>("idLocation")
        private static let photo = Expression<UIImage>("photo")
        
        private static func createTbl(compilation:@escaping(Swift.Result<Connection , Error>)-> Void ){
            guard let db = DB.createConnection() else {
                compilation(.failure(errorDB.connection))
                return
            }
            do {
                try db.run(DB.images.photos.create(ifNotExists: true) { t in
                    t.column(DB.images.id, primaryKey: true)
                    t.column(DB.images.idLocation)
                    t.column(DB.images.photo, unique: true)
                })
                compilation(.success(db))
            }catch let error {
                compilation(.failure(error))
            }
            
        }
        
        static func insert(photo:UIImage ,idLocation:Int64 ,  compilation:@escaping(Swift.Result<String , Error>) -> Void) {
            
            DB.images.createTbl { (result) in
                switch result {
                case .success(let db):
                    do {
                        try db.run(DB.images.photos.insert(DB.images.photo <- photo, DB.images.idLocation <- idLocation))
                        compilation(.success("Ok"))
                    } catch let error {
                        compilation(.failure(error))
                    }
                case .failure(let error):
                    compilation(.failure(error))
                }
            }
        }
        
        static func getPhotos(idLocation:Int64 , compilation:@escaping(Swift.Result< [UIImage] , Error>)->Void) {
            DB.images.createTbl { (result) in
                switch result {
                case .success(let db):
                    do {
                        var photos = [UIImage]()
                        for row in try db.prepare(DB.images.photos.where(self.idLocation == idLocation)) {
                            photos.append(row[photo])
                        }
                        compilation(.success(photos))
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


