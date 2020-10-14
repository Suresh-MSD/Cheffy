//
//  FoodItemCell.swift
//  chef
//
//  Created by Eddie Ha on 20/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class FoodItemCell: UICollectionViewCell {
    //MARK: Properties
    public let CLASS_NAME = FoodItemCell.self.description()
    
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var uivFeaturedImageContainer: UIView!
    @IBOutlet weak var ivFeatureImage: UIImageView!
    @IBOutlet weak var ivFavoriteImage: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblTimeline: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var highlightView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCategoryList(plate: Plate) {
        
        self.highlightView.isHidden = plate.available ?? true
        self.ivFavoriteImage.isHidden = Helper.isLoggedIn() ? false : true
        self.lblFoodName.text = plate.name?.capitalizingFirstLetter()
        self.lblRating.text = "\(plate.AggregateReview?.rating ?? 0.0) (\(plate.AggregateReview?.userCount ?? 0))"
        self.lblTimeline.text = "\(plate.deliveryTime ?? 0) - \((plate.deliveryTime ?? 0) + 5) min"
        
        if (plate.available ?? true) == true {
            self.lblDelivery.text = "Free"
        } else {
            self.lblDelivery.text = "Paid"
        }
        
        if plate.plateImageList?.count ?? 0 > 0{
            if let imageUrl = plate.plateImageList?[0].url {
                self.ivFeatureImage.setImageFromUrl(url: imageUrl)
            }
        }
        
        self.uivFeaturedImageContainer.elevate(elevation: 6, cornerRadius: 15)
    }
}
