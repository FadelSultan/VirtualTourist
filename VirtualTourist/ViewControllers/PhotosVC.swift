//
//  PhotosVC.swift
//  VirtualTourist
//
//  Created by fadel sultan on 11/9/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosVC: UIViewController {
    
    //    outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyPhotos: UIView!
    
    //    variables
    var photos = [mPhoto]()
    var localPhotos = [Photo]()
    
    var locationCoordinate:CLLocationCoordinate2D?
    var pin:Pin?
    var isSavePhotos:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadPhotos()
    }
    
    private func downloadPhotos() {
        
        if let locationCoordinate = locationCoordinate {
            self.photos.removeAll()
            cProgress.start(add: view, text: "Load data")
            Locations.get(url: URLs.getUrl(coordinate: locationCoordinate)) { (result) in
                cProgress.hide()
                switch result {
                case .success(let photos):
                    if photos.count == 0 {
                        self.emptyPhotos.isHidden = false
                        return
                    }
                    self.photos = photos
                    self.collectionView.reloadData()
                case .failure(let error):
                    self.alert(message: error.localizedDescription)
                }
            }
        }
        if !isSavePhotos {
            if let pin = pin {
                do {
                    let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
                    let predicate = NSPredicate(format: "pin == %@", pin)
                    fetchRequest.predicate = predicate
                    self.localPhotos = try DataController.shared.viewContext.fetch(fetchRequest)
                    print(localPhotos.count)
                    self.collectionView.reloadData()
                }catch let error {
                    fatalError(error.localizedDescription)
                }
            }

        }
    }
    
    //    Actions
    @IBAction func btnRefresh(_ sender: UIBarButtonItem) {
        downloadPhotos()
    }
    
}

// MARK:- UICollectionViewDataSource
extension PhotosVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationCoordinate != nil ? photos.count : localPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if locationCoordinate != nil {
            cell.online(photo: self.photos[indexPath.row] , pin: pin)
        }else {
            cell.offline(photo: localPhotos[indexPath.row])
        }
        return cell
    }
}

extension PhotosVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(3 - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(3))
            return CGSize(width: size, height: size)
        }
        return CGSize(width: 131, height: 131)
    }
    
}
