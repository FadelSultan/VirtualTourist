//
//  DataController.swift
//  VirtualTourist
//
//  Created by fadel sultan on 12/3/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import CoreData
import MapKit
class DataController {
    
    static let shared = DataController()
    var localDataPins = [Pin]()
    
    private let presentContainer = NSPersistentContainer(name: "VirtualTourist")
    
    var viewContext : NSManagedObjectContext {
        return presentContainer.viewContext
    }
    
    func load() {
        presentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            do {
                let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
                self.localDataPins = try self.viewContext.fetch(fetchRequest)
            }catch let error  {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func insert(pin:CLLocationCoordinate2D , compilation:(Result<Pin , Error>)->Void) {
        let newPin = Pin(context: viewContext)
        newPin.latitude = Double(pin.latitude)
        newPin.longitude = Double(pin.longitude)
        newPin.creationDate = Date()
        do {
            try viewContext.save()
            compilation(.success(newPin))
        }catch let error {
            compilation(.failure(error))
        }
    }
    
    func insert(imageData:Data ,imageUrl:URL ,pin:Pin , compilation:(Result<Photo , Error>)->Void) {
        let newPhoto = Photo(context: viewContext)
        newPhoto.imageData = imageData
        newPhoto.imageURL = imageUrl
        newPhoto.creationDate = Date()
        newPhoto.pin = pin
        do {
            try viewContext.save()
            compilation(.success(newPhoto))
        }catch let error {
            compilation(.failure(error))
        }
    }
}
