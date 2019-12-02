//
//  DB.swift
//  VirtualTourist
//
//  Created by fadel sultan on 12/2/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import SQLite


enum errorDB: Error {
    case connection
    case createTable
    case insertValue
    case selectRows
    case unknown
}

struct DB {
    private static let photos = Table("photos")

    internal static func createConnection() -> Connection? {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        do {
            print("path: " , path)
            return try Connection("\(path)/db.sqlite3")
        }catch {
            return nil
        }
    }
    
}

// Add extension images to sqlite.swift
extension UIImage: Value {
    public class var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    public class func fromDatatypeValue(_ blobValue: Blob) -> UIImage {
        return UIImage(data: Data.fromDatatypeValue(blobValue))!
    }
    public var datatypeValue: Blob {
        return self.pngData()!.datatypeValue
    }
}
