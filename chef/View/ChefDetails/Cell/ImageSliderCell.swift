//
//  ImageSliderCell.swift
//  chef
//
//  Created by Eddie Ha on 23/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ImageSliderCell: UICollectionViewCell {
    //MARK: Properties
    public let  CLASS_NAME = ChefInfoCell.self.description()
    
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var ivSliderImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
