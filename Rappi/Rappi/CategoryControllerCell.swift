//
//  AppCell.swift
//  Rappi
//
//  Created by Kevin Rojas Navarro on 6/11/16.
//  Copyright © 2016 Kevin Rojas Navarro. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AppsCell: BaseCell {
    
    var appAttr: JSON = [] {
        didSet {
            nameLabel.text = appAttr["im:name"]["label"].stringValue
            
            ImageLoader.sharedLoader.imageForUrl(appAttr["im:image"][2]["label"].stringValue, completionHandler:{(image: UIImage?, url: String) in
                self.appImageView.image = image!
            })
        }
    }
    
    let appImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0.8
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = .Center
        return label
    }()
    
    override func setupViews() {
        
        addSubview(appImageView)
        addSubview(dividerLineView)
        
        setupContainerView()
        
        appImageView.image = UIImage(named: "image")
        
        addConstraintsWithFormat("H:[v0(68)]", views: appImageView)
        addConstraintsWithFormat("V:|-12-[v0(68)]", views: appImageView)
        
        addConstraint(NSLayoutConstraint(item: appImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat("H:|-5-[v0]-5-|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        
        addSubview(containerView)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: containerView)
        addConstraintsWithFormat("V:[v0(30)]|", views: containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addConstraintsWithFormat("H:|[v0]|", views: nameLabel)
        containerView.addConstraintsWithFormat("V:[v0]-1-|", views: nameLabel)
    }
}



class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor.redColor()
    }
}