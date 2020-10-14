//
//  ReceiptHeaderCell.swift
//  chef
//
//  Created by Eddie Ham on 1/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ReceiptHeaderCell: UICollectionViewCell {
    
    //MARK: Properties
    public let CLASS_NAME = ReceiptHeaderCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
