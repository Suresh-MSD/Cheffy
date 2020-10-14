//
//  CartCustomOrderCell.swift
//  chef
//
//  Created by Eddie Ha on 19/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CartCustomOrderCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = CartCustomOrderCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var uivContentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivFoodImage: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
