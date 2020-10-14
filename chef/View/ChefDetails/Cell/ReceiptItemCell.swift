//
//  ReceiptItemCell.swift
//  chef
//
//  Created by Eddie Ha on 1/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ReceiptItemCell: UICollectionViewCell {

    //MARK: Properies
    public let CLASS_NAME = ReceiptItemCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var lblReceiptItem: UILabel!
    @IBOutlet weak var lblItemDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
