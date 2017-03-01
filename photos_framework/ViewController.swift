//
//  ViewController.swift
//  photos_framework
//
//  Created by Tim Beals on 2017-02-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import Photos

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var assetsPhotoFetch: PHFetchResult<PHAsset>?
    
    lazy var cellSize: CGSize = {
        let side: CGFloat = (self.collectionView!.bounds.width / 2) - 12
        let size = CGSize(width: side, height: side)
        return size
    }()
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Photo Collection"
        
        setupCollectionView()
        
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
            switch status {
            case .authorized:
                self.fetchPhotos()
            default:
                self.showUnauthorizedAlert()
            }
        }
    
    }
    
    func setupCollectionView() {
        
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        
    }
    
    
    //MARK: Collection view delegate methods
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfItems = self.assetsPhotoFetch?.count {
            return numberOfItems
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoCollectionViewCell
        
        if let asset = assetsPhotoFetch?[indexPath.item] {
            
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
          
            PHImageManager.default().requestImage(for: asset, targetSize: cellSize, contentMode: .aspectFill, options: options, resultHandler: { (image: UIImage?, info: [AnyHashable: Any]?) in
                
                cell.imageView.image = image
            })
            
        }
        
        return cell
    }
    

    //MARK: FlowLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let livePhotoVC = LivePhotoViewController()
        self.navigationController?.pushViewController(livePhotoVC, animated: true)
        
    }
    
    
    func fetchPhotos() {
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        
        //the %d is refering to the raw value of the photoLive media subtype
        let predicate = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)
        
        let options = PHFetchOptions()
        options.sortDescriptors = [sortDescriptor]
        options.predicate = predicate
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            self.assetsPhotoFetch = PHAsset.fetchAssets(with: options)
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func showUnauthorizedAlert() {
        
        let alert = UIAlertController(title: "No access to photo Library", message: "click Settings to turn on access permission", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action: UIAlertAction) in
            
            let url = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(url!, options: ["":""], completionHandler: nil)
            
            return
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

