//
//  AppDelegate.swift
//  Rappi
//
//  Created by Kevin Rojas Navarro on 6/10/16.
//  Copyright © 2016 Kevin Rojas Navarro. All rights reserved.
//

import UIKit


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = Colors.navigationColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        application.statusBarStyle = .LightContent
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        let categoryController = CategoryController(collectionViewLayout: layout)
        window?.rootViewController = UINavigationController(rootViewController: categoryController)
        
        
        return true
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return checkOrientation(self.window?.rootViewController)
    }
    
    func checkOrientation(viewController:UIViewController?)-> UIInterfaceOrientationMask {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return .Portrait
        case .Pad:
            return .Landscape
            
        case .Unspecified:
            return .All
            
        default:
            break
        }
        
        return checkOrientation(viewController!.presentedViewController)
    }

    
}

