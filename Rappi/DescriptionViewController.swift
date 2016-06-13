//
//  DescriptionViewController.swift
//  Rappi
//
//  Created by Kevin Rojas Navarro on 6/10/16.
//  Copyright © 2016 Kevin Rojas Navarro. All rights reserved.
//

import UIKit
import SwiftyJSON
import TransitionTreasury
import TransitionAnimation
import PMAlertController

class DescriptionViewController: UIViewController, UIScrollViewDelegate, NavgationTransitionable {
    
    var tr_pushTransition: TRNavgationTransitionDelegate?
    
    var app : JSON = [] {
        didSet {
            
            let name : String = app["im:name"]["label"].stringValue
            let category : String = app["category"]["attributes"]["label"].stringValue
            
            self.navigationItem.titleView = NamingBar.titleForNavigationBar(name, subtitle: category)
            navigationItem.title = app["im:name"]["label"].stringValue
            
            ImageLoader.sharedLoader.imageForUrl(app["im:image"][2]["label"].stringValue, completionHandler:{(image: UIImage?, url: String) in
                self.appImage.image = image!
            })
            
            appName.text = name
            appRights.text = app["rights"]["label"].stringValue
            appSummary.text = app["summary"]["label"].stringValue
            
            if let price: Double = Double(app["im:price"]["attributes"]["amount"].stringValue)! {
                if price == 0.0 {
                    appPrice.text = "Free"
                }
            }
            
        }
    }
    
    let appImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    let appName: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFontOfSize(16)
        name.textAlignment = .Left
        name.numberOfLines = 0
        return name
    }()
    
    let appRights: UILabel = {
        let rights = UILabel()
        rights.font = UIFont.systemFontOfSize(12)
        return rights
    }()
    
    let appCategory: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = .Center
        label.numberOfLines = 0
        return label
    }()
    
    let appPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        return label
    }()

    let appSummary : UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.textAlignment = .Center
        textView.font = UIFont.systemFontOfSize(13)
        textView.textColor = UIColor(white: 0.4, alpha: 0.8)
        textView.editable = false
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.text = "Description"
        return label
    }()
    
    let divisorScreen : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        setupNavBarButtons()
        
        self.view.addSubview(self.viewContainer)
    
        self.viewContainer.addSubview(appImage)
        self.viewContainer.addSubview(appName)
        
        self.viewContainer.addSubview(appRights)
        
        self.viewContainer.addSubview(appPrice)
        
        self.view.addSubview(textLabel)
        self.view.addSubview(appSummary)
        self.view.addSubview(divisorScreen)
        
        setupConstraints()

    }
    
    func setupConstraints() {
        
        addConstraintsWithFormat("H:|[v0]|", views: divisorScreen)
        addConstraintsWithFormat("V:|-155-[v0(0.7)]", views: divisorScreen)
        
        addConstraintsWithFormat("H:|[v0]|", views: viewContainer)
        addConstraintsWithFormat("V:|-64-[v0(92)]", views: viewContainer)
        
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: textLabel)
        addConstraintsWithFormat("V:|-165-[v0]", views: textLabel)
        
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: appSummary)
        addConstraintsWithFormat("V:|-190-[v0]-12-|", views: appSummary)
        
        addConstraintsWithFormat("H:[v0]-12-|", views: appPrice)
        addConstraintsWithFormat("V:[v0]-12-|", views: appPrice)
        
        addConstraintsWithFormat("H:|-92-[v0]|", views: appName)
        addConstraintsWithFormat("V:|-12-[v0]-4-[v1]", views: appName, appRights)
        
        addConstraintsWithFormat("H:|-92-[v0]|", views: appRights)
        
        
        addConstraintsWithFormat("H:|-12-[v0(68)]", views: appImage)
        addConstraintsWithFormat("V:|-12-[v0(68)]", views: appImage)
    }
    
    func setupNavBarButtons() {
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: #selector(handleBack))
        let hRefButton = UIBarButtonItem(image: UIImage(named: "world-wide-web"), style: .Plain, target: self, action: #selector(handleOpen))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = hRefButton
    }
    
    func handleBack() {
        navigationController?.tr_popViewController({ () -> Void in
            print("Pop.")
        })
    }
    
    func handleOpen() {
        if let url = NSURL(string: app["link"]["attributes"]["href"].stringValue.componentsSeparatedByString("?")[0].stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
}