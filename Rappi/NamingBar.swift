//
//  GlobalUtilities.swift
//  WIIFM
//
//  Created by Kevin on 12/22/15.
//  Copyright © 2015 Kevin. All rights reserved.
//

import Foundation
import UIKit

public class NamingBar {
    
    class func titleForNavigationBar(title: String, subtitle: String) -> UIView {
        let attributedString = NSMutableAttributedString(string: subtitle)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.4), range: NSRange(location: 0, length: subtitle.characters.count))
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "SF UI Text Semibold", size: 17.0)
        titleLabel.font = titleLabel.font.fontWithSize(17)
        
        if title.containsString("-") {
            if let name: String = title.componentsSeparatedByString("-")[0] {
                titleLabel.text = name
            }
        } else if title.containsString("–") {
            if let name: String = title.componentsSeparatedByString("–")[0] {
                titleLabel.text = name
            }
        } else {
            titleLabel.text = title
        }
        
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRectMake(0, 20, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        subtitleLabel.textColor = UIColor(red: 65/255, green: 69/255, blue: 76/255, alpha: 1)
        subtitleLabel.font = UIFont(name: "SF UI Text Medium", size: 4.0)
        subtitleLabel.font = subtitleLabel.font.fontWithSize(10)
        subtitleLabel.text = subtitle
        subtitleLabel.attributedText = attributedString
        subtitleLabel.sizeToFit()
        
        let titleWidth = titleLabel.frame.size.width
        let subtitleWidth = subtitleLabel.frame.size.width
        
        let completeTitle = UIView(frame: CGRectMake(0, 0, max(subtitleWidth, titleWidth), 30))
        completeTitle.addSubview(titleLabel)
        completeTitle.addSubview(subtitleLabel)
        
        let widthDiff: CGFloat = subtitleWidth - titleWidth
        
        if widthDiff > 0 {
            var frame: CGRect = titleLabel.frame
            frame.origin.x = widthDiff / 2
            titleLabel.frame = CGRectIntegral(frame)
        } else {
            var frame: CGRect = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            subtitleLabel.frame = CGRectIntegral(frame)
        }
        
        return completeTitle
    }
    
}