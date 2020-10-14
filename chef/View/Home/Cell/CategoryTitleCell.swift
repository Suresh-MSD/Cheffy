//
//  CategoryTitleCell.swift
//  chef
//
//  Created by Eddie Ha on 20/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CategoryTitleCell: UICollectionViewCell {

    //MARK: Properties
    public let  CLASS_NAME = CategoryTitleCell.self.description()
    
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
