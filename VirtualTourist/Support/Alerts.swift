//
//  Alerts.swift
//  VirtualTourist
//
//  Created by fadel sultan on 12/2/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(message:String , compilationHandler:(()->Void)? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
            compilationHandler!()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
