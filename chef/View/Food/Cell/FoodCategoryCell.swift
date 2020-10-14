//
//  FoodCell.swift
//  chef
//
//  Created by Eddie Ha on 22/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class FoodCategoryCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = FoodCategoryCell.self.description()
    
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var ivFeaturedImage: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var highlightView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(food: FoodCategory) {
        self.lblCategory.text = food.name
        guard let imageUrl = food.url else {return}
        self.ivFeaturedImage.setImageFromUrl(url: imageUrl)
        self.uivContainer.elevate(elevation: 3, cornerRadius: 7.5)
        
        
    }

    override var isHighlighted: Bool {
        didSet {
            self.highlightView.backgroundColor = isHighlighted ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }
}
