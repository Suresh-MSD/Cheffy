//
//  ChefDetailsFoodItemCell.swift
//  chef
//
//  Created by Eddie Ha on 26/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ChefDetailsFoodItemCell: UICollectionViewCell {

    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var ivFetauredImage: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblDeliveryType: UILabel!
    @IBOutlet weak var btnOffer: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
