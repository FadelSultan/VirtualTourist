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
    var counterPages = 1
    var locationCoordinate:CLLocationCoordinate2D?
    var pin:Pin?
    var isSavePhotos:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadPhotos(page: counterPages)
    }
    
    private func downloadPhotos(page:Int) {
        
        if let locationCoordinate = locationCoordinate {
            
            cProgress.start(add: view, text: "Load data \n Page:\(page)")
            Locations.get(url: URLs.getUrl(coordinate: locationCoordinate , page: page)) { (result) in
                cProgress.hide()
                switch result {
                case .success(let photos):
                    if photos.count == 0 && page == 1{
                        self.emptyPhotos.isHidden = false
                        return
                    }
                     if photos.count == 0 && page != 1{
                        self.alert(message: "No more photos")
                        self.counterPages = 1
                        return
                    }
                    self.photos.removeAll()
                    self.photos = photos
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
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
                    self.collectionView.reloadData()
                }catch let error {
                    fatalError(error.localizedDescription)
                }
            }

        }
    }
    
    //    Actions
    @IBAction func btnRefresh(_ sender: UIBarButtonItem) {
        counterPages += 1
        downloadPhotos(page: counterPages)
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


extension PhotosVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DataController.shared.deletePhoto(photo: localPhotos[indexPath.row]) { (result) in
            switch result {
            case .success(_):
                collectionView.deleteItems(at: [indexPath])
                localPhotos.remove(at: indexPath.row)
            case .failure(let error):
                alert(message: error.localizedDescription)
            }
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
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
