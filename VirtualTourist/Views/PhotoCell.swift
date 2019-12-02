//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by fadel sultan on 11/9/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import Kingfisher
import JGProgressHUD

class PhotoCell: UICollectionViewCell {
    
    //    outlet
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var IVphoto: UIImageView!
    
//    General
    let hud = JGProgressHUD(style: .light)
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        hud.show(in: viewBackground)
    }
    
    func online(photo:Photo , idLocation:Int64? = nil) {
        
        let emptyPhoto =  UIImage(named: "noimage")
        
        guard let urlPath = photo.url_z else {
            self.IVphoto.image = emptyPhoto
            return
        }
        guard let url = URL(string: urlPath) else {
            self.IVphoto.image = emptyPhoto
            return
        }
        
        if let idLocation = idLocation {
            self.IVphoto.kf.setImage(with: url) { (result) in
                switch result {
                case .success(let value):
                    DB.images.insert(photo: value.image, idLocation: idLocation) { (resultInsert) in
                        switch resultInsert {
                        case .success(let msg):
                            print(msg)
                        case .failure(let error):
                            print(error)
                        }
                    }
                case .failure(_):
                    print("Not found images")
                }
            }
        }
        
    }
    
    func offline(photo:UIImage) {
        IVphoto.image = photo
    }
}
