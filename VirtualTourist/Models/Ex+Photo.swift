//
//  Ex+Photo.swift
//  VirtualTourist
//
//  Created by fadel sultan on 12/3/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import UIKit

extension Photo {
    
    func set(photo:UIImage) {
        imageData = photo.pngData()
    }
    
    func getPhoto() -> UIImage? {
        return (imageData == nil) ? nil : UIImage(data: imageData!)
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
