//
//  API.swift
//  VirtualTourist
//
//  Created by fadel sultan on 11/28/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import Alamofire

struct API:Codable {
    static func webService(url:String  , compilationHandler:@escaping(Swift.Result<Data, Error>)->Void) {
        Alamofire.request(url).responseData { (response) in
            switch response.result {
            case .failure(let error):
                compilationHandler(.failure(error))
            case .success( let data):
                do {
                    try compilationHandler(.success(data.toData()))
                }catch let error {
                    compilationHandler(.failure(error))
                }
            }
        }
    }
}
