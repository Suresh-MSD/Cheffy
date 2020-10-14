//
//  HomePickupDropoffCell.swift
//  cheffydriver
//
//  Created by Eddie Ha on 3/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class DeliveryPickupDropoffCell: UICollectionViewCell {
    //MARK: Properties
    public let CLASS_NAME = DeliveryPickupDropoffCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var uivContent: UIView!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDropoff: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
