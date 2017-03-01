//
//  PhotoCollectionViewCell.swift
//  photos_framework
//
//  Created by Tim Beals on 2017-02-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView?.backgroundColor = UIColor.blue
        setupCell()
    }
    
    func setupCell() {
        addSubview(imageView)
        
        addConstrainstswith(format: "H:|[v0]|", views: imageView)
        addConstrainstswith(format: "V:|[v0]|", views: imageView)
        //imageView.image = UIImage(named: "homer_profile")

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
