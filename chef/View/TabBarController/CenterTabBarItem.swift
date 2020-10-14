//
//  CenterTabBarItem.swift
//  chef
//
//  Created by Eddie Ha on 27/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CenterTabBarItem: UITabBarItem {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.image = UIImage(named: "ic_tab_add")?.withRenderingMode(.alwaysOriginal)
        self.selectedImage = UIImage(named: "ic_tab_add")?.withRenderingMode(.alwaysOriginal)
    }
}
