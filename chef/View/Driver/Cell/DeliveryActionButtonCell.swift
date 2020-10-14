//
//  HomeActionButtonCell.swift
//  cheffydriver
//
//  Created by Eddie Ha on 3/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class DeliveryActionButtonCell: UICollectionViewCell {
    
    //MARK: Properties
    public let CLASS_NAME = DeliveryActionButtonCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var btnAcceptOrder: UIButton!
    @IBOutlet weak var btnRejectOrder: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnAcceptOrder.elevate(elevation: 10, cornerRadius: 8)
    }

    
    //MARK: Actions
    //when click on accept order
    @IBAction func onClickAcceptOrder(_ sender: UIButton) {
    }
    
    //when click on decline order
    @IBAction func onClickRejectOrder(_ sender: UIButton) {
    }
    
    
}
