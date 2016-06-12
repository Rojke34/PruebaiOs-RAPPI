//
//  ViewController.swift
//  Rappi
//
//  Created by Kevin Rojas Navarro on 6/10/16.
//  Copyright © 2016 Kevin Rojas Navarro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PMAlertController
import NVActivityIndicatorView
import AZDropdownMenu
import TransitionTreasury
import TransitionAnimation

class CategoryController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var selectedCategory : String = ""
    var menu = AZDropdownMenu?()
    var divisorCollectionViewCell : CGFloat = 2.0
    
    var categories: [String] = []
    var itemShown = [Bool]()
    var appsArray = [JSON]()
    var filteredAppsArray = [JSON]()
    var isFiltered: Bool = false
    var limit : Int = 20
    var baseURL: String = "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json"
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = NamingBar.titleForNavigationBar("iBox", subtitle: "Apps Library")
        
        setupCollectionView()
        setupNavBarButtons()
        setupCategories()
        prepareActivityIndicatorView()
        determineDevice()
        connectToNetwork()
    }
    
    func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.registerClass(AppsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupNavBarButtons() {
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(showDropdown))
        let moreButton = UIBarButtonItem(image: UIImage(named: "more"), style: .Plain, target: self, action: #selector(handleMore))
        self.navigationItem.leftBarButtonItem = moreButton
        self.navigationItem.rightBarButtonItem = menuButton
    }

    func prepareActivityIndicatorView() {
        let xPos = (self.view.bounds.width / 2) - 50
        let yPos = (self.view.bounds.height / 2) - 50
    
        activityIndicatorView.frame = CGRectMake(xPos, yPos, 100, 100)
        activityIndicatorView.padding = 20
        activityIndicatorView.type = .Pacman
        activityIndicatorView.color = Colors.navigationColor
        self.view.addSubview(activityIndicatorView)
    }
    
    func determineDevice() {
        switch UIDevice.currentDevice().userInterfaceIdiom {
            case .Phone:
                divisorCollectionViewCell = 2.0
                break
            case .Pad:
                divisorCollectionViewCell = 4.0
                break
            case .Unspecified:
                print("?")
                break
            default:
                break
        }
    }
    
    func handleMore() {
        limit += 10
        
        baseURL = "https://itunes.apple.com/us/rss/topfreeapplications/limit=\(limit)/json"
        connectToNetwork()
    }
    
    func showDropdown() {
        if (self.menu!.isDescendantOfView(self.view) == true) {
            self.menu!.hideMenu()
        } else {
            self.menu!.showMenuFromView(self.view)
        }
    }
    
    func connectToNetwork() {
        if Reachability.isConnectedToNetwork() {
            activityIndicatorView.startAnimation()
            setupData()
            
        } else {
            
            displayAlertControllerConnection()
        }
    }
    
    func displayAlertControllerConnection() {
        let alertVC = PMAlertController(title: "Connect", description: "Unable to connect to the Internet", image: UIImage(named: "satellite"), style: .Alert)
        
        alertVC.addAction(PMAlertAction(title: "Reload", style: .Default, action: { () in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.connectToNetwork()
        }))
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltered ? filteredAppsArray.count : appsArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! AppsCell
        
        let app = isFiltered ? filteredAppsArray[indexPath.item] : appsArray[indexPath.item]
        
        cell.appAttr = app
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width / divisorCollectionViewCell, 110)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = DescriptionViewController()
        
        controller.app = isFiltered ? filteredAppsArray[indexPath.item] : appsArray[indexPath.item]
        
        navigationController?.tr_pushViewController(controller, method: TRPushTransitionMethod.Page, completion: {
            print("finish")
        })
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0
        UIView.animateWithDuration(0.5) { cell.alpha = 1 }
        
        if itemShown[indexPath.row] == false {
            if indexPath.row % 2 == 0 {
                let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
                cell.layer.transform = rotationTransform
                
                UIView.animateWithDuration(0.5) { cell.layer.transform = CATransform3DIdentity }
            } else {
                let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 1000, 10, 0)
                cell.layer.transform = rotationTransform
                
                UIView.animateWithDuration(0.5) { cell.layer.transform = CATransform3DIdentity }
            }
            
            itemShown[indexPath.row] = true
        }

    }
    
    func setupData() {
        Alamofire.request(.GET, baseURL, parameters: nil)
            .responseJSON { response in
        
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        self.appsArray = json["feed"]["entry"].arrayValue
                        self.navigationItem.titleView = NamingBar.titleForNavigationBar("iBox", subtitle: "\(self.appsArray.count) Apps")
                        
                        self.itemShown = [Bool](count: self.appsArray.count,repeatedValue: false)
                        
                        self.collectionView?.reloadData()
                        
                        self.activityIndicatorView.stopAnimation()
                        
                        self.setupCategories()
                        
                        if self.isFiltered {
                            self.filterCollectionView(self.selectedCategory)
                        }
                        
                    }
                case .Failure(let error):
                    print(error)
                    
                }
        }
    }
    
    func setupCategories() {
        self.categories.removeAll()
        self.categories.append("All")
        for app in self.appsArray {
            self.categories.append(app["category"]["attributes"]["label"].stringValue)
        }
        
        let unique = self.categories.unique
        let ordered = unique.sort()
        
        self.menu = AZDropdownMenu(titles: ordered)
        
        self.menu!.cellTapHandler = { [weak self] (indexPath: NSIndexPath) -> Void in
            if indexPath.item == 0 {
                self?.restoreCollectionView()
            } else {
                self!.selectedCategory = ordered[indexPath.item]
                self!.filterCollectionView(self!.selectedCategory)
            }
        }
    }
    
    func filterCollectionView(item: String) {
        self.isFiltered = true
        self.filteredAppsArray = self.appsArray.filter{ ($0["category"]["attributes"]["label"].stringValue == item )}
        
        collectionView?.reloadData()
    }
    
    func restoreCollectionView() {
        self.isFiltered = false
        collectionView?.reloadData()
    }
}
