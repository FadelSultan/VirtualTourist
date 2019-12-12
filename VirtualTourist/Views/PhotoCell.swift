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
    
    func online(photo:mPhoto , pin:Pin? = nil) {
        
        let emptyPhoto =  UIImage(named: "noimage")
        
        guard let urlPath = photo.url_z else {
            self.IVphoto.image = emptyPhoto
            return
        }
        guard let url = URL(string: urlPath) else {
            self.IVphoto.image = emptyPhoto
            return
        }
        if let pin = pin {
            self.IVphoto.kf.setImage(with: url) { (result) in
                switch result {
                case .success(let value):
                    if let imageData = value.image.pngData() {
                        DataController.shared.insert(imageData: imageData , imageUrl: url, pin: pin) { (resultSave) in
                            switch resultSave {
                                
                            case .success(_):
                                print("Image save")
                            case .failure(let error):
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                    
                case .failure(_):
                    print("Nothing image")
                }
            }
        }else {
            self.IVphoto.kf.setImage(with: url)
        }
    
    }
    
    func offline(photo:Photo) {
        if let image = photo.imageData {
            IVphoto.image = UIImage(data: image)
        }
        
    }
}

