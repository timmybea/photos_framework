//
//  Helpers.swift
//  photos_framework
//
//  Created by Tim Beals on 2017-02-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstrainstswith(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            
            let string = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[string] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views:viewsDictionary))
    }

    
}
