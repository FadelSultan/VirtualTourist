//
//  ViewController.swift
//  VirtualTourist
//
//  Created by fadel sultan on 11/9/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController {
    
    
    //    outlet
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        loadLocalLocations()
        
    }
    
    
    @IBAction func btnLongClickOnMap(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began  {
            let touchLocation = (sender as AnyObject).location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            addPin(to: locationCoordinate)
        }
    }
    
    private func loadLocalLocations() {
        for pin in DataController.shared.localDataPins {
            addPin(to: pin.coordinate , isSavePin: false)
        }
    }
    
    
    private func addPin(to:CLLocationCoordinate2D , isSavePin:Bool = true) {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: to.latitude, longitude:to.longitude)
        annotation.coordinate = centerCoordinate
        mapView.addAnnotation(annotation)

        if isSavePin {
            DataController.shared.insert(pin: centerCoordinate) { (result) in
                switch result {
                case .failure(let er):
                    self.alert(message: er.localizedDescription)
                case .success(let pin):
                    self.openPhotosVC(location: pin.coordinate , pin: pin , isSavePhoto: true)
                }
            }
        }
    }
    
    private func openPhotosVC(location:CLLocationCoordinate2D?=nil , pin:Pin? = nil , isSavePhoto:Bool = false) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(withIdentifier: "PhotosVC") as! PhotosVC
        if let location = location {
            vc.locationCoordinate = location
        }
        if let pin = pin {
            vc.pin = pin
        }
        vc.isSavePhotos = isSavePhoto
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- MKMapViewDelegate
extension MapVC : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let location = view.annotation?.coordinate {
            let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
            do {
                let result = try DataController.shared.viewContext.fetch(fetchRequest)
                if let pin = result.first(where: {$0.latitude == location.latitude && $0.longitude == location.longitude}) {
                    openPhotosVC(pin: pin)
                }
            }catch let error {
                fatalError(error.localizedDescription)
            }
        }
    }
}
