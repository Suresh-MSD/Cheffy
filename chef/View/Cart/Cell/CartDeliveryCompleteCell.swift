//
//  CartDeliveryCompleteCell.swift
//  chef
//
//  Created by Eddie Ha on 19/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Cosmos

class CartDeliveryCompleteCell: UICollectionViewCell {
    
    //MARK: Properties
    public let CLASS_NAME = CartDeliveryCompleteCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var uivContentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivFoodImage: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnGiveReview: UIButton!
    @IBOutlet weak var uivReviewBox: CosmosView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
