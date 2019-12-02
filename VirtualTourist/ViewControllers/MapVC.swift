//
//  ViewController.swift
//  VirtualTourist
//
//  Created by fadel sultan on 11/9/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import MapKit

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
        for location in modelLocation.coordinates {
            addPin(to: location.coordinate)
        }
    }
    
    
    private func addPin(to:CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: to.latitude, longitude:to.longitude)
        annotation.coordinate = centerCoordinate
        mapView.addAnnotation(annotation)
        DB.location.insert(location: centerCoordinate) { (result) in
            switch result {
            case .success(let id):
                self.OpenPhotosVC(location: centerCoordinate , idLocation: id)
                let newLocation = modelLocation(id: id, coordinate: centerCoordinate)
                modelLocation.coordinates.append(newLocation)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func OpenPhotosVC(location:CLLocationCoordinate2D?=nil , idLocation:Int64? = nil) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(withIdentifier: "PhotosVC") as! PhotosVC
        if let location = location {
            vc.locationCoordinate = location
        }
        if let idLocation = idLocation {
            vc.idLocation = idLocation
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- MKMapViewDelegate
extension MapVC : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let location = view.annotation?.coordinate {
            let location = modelLocation.coordinates.last(where: {$0.coordinate.latitude == location.latitude && $0.coordinate.longitude == location.longitude})
            OpenPhotosVC(idLocation: location?.id)
        }
    }
}
