//
//  ColorGenerator.swift
//  chef
//
//  Created by Eddie Ha on 27/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ColorGenerator: NSObject {
    //Hex color with  alpha generator
    static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }

    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}

enum OriginalColors: String {
    case primaryText = "555555"
    case secondaryText = "AAAAAA"
    case primary = "EA1D2C"
    case unselected = "DDDDDD"
    case formUnderBar = "CCCCCC"
}

extension OriginalColors {
    func uiColor() -> UIColor {
        return UIColor(hex: self.rawValue)
    }
}
