//
//  cProgress.swift
//  VirtualTourist
//
//  Created by fadel sultan on 12/1/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import JGProgressHUD

class cProgress {
    private static let hud = JGProgressHUD(style: .dark)
    
    class func start(add inView:UIView , text:String = "Loading") {
        hud.textLabel.text = text
        hud.show(in: inView)
    }
    
    class func change(text:String) {
        hud.textLabel.text = text
    }
    
    class func hide(afterDelay:Double = 0.0) {
        hud.dismiss(afterDelay: afterDelay)
    }
}

extension UIImageView {
    func addProgress(isHidden:Bool = false) {
        let hud = JGProgressHUD(style: .light)
        if !isHidden {
            hud.show(in: self)
        }else {
            hud.dismiss()
        }
    }
}
