//
//  Colors.swift
//  Rappi
//
//  Created by Kevin Rojas Navarro on 6/10/16.
//  Copyright © 2016 Kevin Rojas Navarro. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    
    static let navigationColor = UIColor(red: 255.0/255.0, green: 111.0/255.0, blue: 3.0/255.0, alpha: 1)
    static let navigationItemColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 255.0/255.0, alpha: 1)
    
}

enum UIUserInterfaceIdiom : Int {
    case Unspecified
    
    case Phone // iPhone and iPod
    case Pad // iPad 
}

extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}