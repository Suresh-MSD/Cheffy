//
//  CartTabBarCell.swift
//  chef
//
//  Created by Eddie Ha on 17/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CartTabBarCell: UICollectionViewCell {
    
    //MARK: Properties
    public let CLASS_NAME = CartTabBarCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var uivIndicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
