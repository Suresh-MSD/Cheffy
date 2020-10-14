//
//  CheffyTabBar.swift
//  chef
//
//  Created by Eddie Ha on 20/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CheffyTabBar: UITabBar {
    @IBInspectable var height: CGFloat = 0.0
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            
            if #available(iOS 11.0, *) {
                sizeThatFits.height = height + window.safeAreaInsets.bottom
            } else {
                sizeThatFits.height = height
            }
        }
        return sizeThatFits
    }
}
