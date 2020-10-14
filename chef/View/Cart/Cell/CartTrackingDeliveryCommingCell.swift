//
//  CartTrackingCustomOrderCell.swift
//  chef
//
//  Created by Eddie Ha on 18/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CartTrackingCell: UICollectionViewCell {
    
    //MARK: Properties
    public let CLASS_NAME = CartTrackingCustomOrderCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var uivContentView: UIView!
    @IBOutlet weak var ivFoodImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTimeline: UILabel!
    @IBOutlet weak var btnViewDetails: UIButton!
    @IBOutlet weak var btnDeliveryStatus: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    //MARK: Actions
    //when tap on view details
    @IBAction func onTapViewDetails(_ sender: UIButton) {
    }
    
    //when tap on delivery status
    @IBAction func onTapDeliveryStatus(_ sender: UIButton) {
    }
    
}
