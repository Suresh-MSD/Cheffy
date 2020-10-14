//
//  ProfileFoodItemswift
//  chef
//
//  Created by Eddie Ha on 29/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ProfileFoodItemCell: UICollectionViewCell {

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
    @IBOutlet weak var btnFav: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setFavoriteData(model: Plate) {
        
        lblFoodName.text = model.name?.capitalizingFirstLetter()
        lblRating.text = "\(model.rating ?? 0)"
        lblTimeline.text = "\(model.deliveryTime ?? 0)"
        lblDelivery.text = model.deliveryType?.capitalizingFirstLetter()
        
        if model.plateImageList?.count ?? 0 > 0{
            if let imageUrl = model.plateImageList?[0].url {
                self.ivFeatureImage.setImageFromUrl(url: imageUrl)
            }
        }
        
        //ivFeatureImage.image = UIImage(named: profileFood.featuredImage!)
    }
    
}
