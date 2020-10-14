//
//  ReceiptImageCell.swift
//  chef
//
//  Created by Eddie Ha on 2/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ReceiptImageCell: UICollectionViewCell {
    //MARK: Properies
    public let CLASS_NAME = ReceiptImageCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var lblReceiptTitle: UILabel!
    @IBOutlet weak var ivReceiptImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
