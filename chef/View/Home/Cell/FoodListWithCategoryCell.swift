//
//  FoodListWithCategoryCell.swift
//  chef
//
//  Created by Eddie Ha on 20/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher

class FoodListWithCategoryCell: UICollectionViewCell {
    
    //MARK: Properties
    public let CLASS_NAME = FoodListWithCategoryCell.self.description()
    public var foodList = [Food]()
    open var plateList = [Plate](){
        didSet{
            self.cvFoodList.reloadData()
        }
    }
    public var onPress: ((_ plate: Plate) -> ())?
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var cvFoodList: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialization()
    }
    
    private func initialization() -> Void {
        cvFoodList.delegate = self
        cvFoodList.dataSource = self
        let nibForFoodItemCell = UINib(nibName: "FoodItemCell", bundle: nil)
        cvFoodList?.register(nibForFoodItemCell, forCellWithReuseIdentifier: "FoodItemCell")
    }
    
}

extension FoodListWithCategoryCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if plateList.isEmpty{
            collectionView.setEmptyMessage("No plates available")
        }else{
            collectionView.restore()
        }
        return plateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvFoodList.frame.width-70, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemCell", for: indexPath) as! FoodItemCell
        
        let plate = plateList[indexPath.row]
        cell.highlightView.isHidden = plate.available ?? true
        cell.ivFavoriteImage.isHidden = Helper.isLoggedIn() ? false : true
        cell.lblFoodName.text = plate.name?.capitalizingFirstLetter()
        cell.lblRating.text = "\(plate.AggregateReview?.rating ?? 0.0) (\(plate.AggregateReview?.userCount ?? 0))"
        cell.lblTimeline.text = "\(plate.deliveryTime ?? 0) - \((plate.deliveryTime ?? 0) + 5) min"
        cell.lblDelivery.text = plate.deliveryType?.capitalizingFirstLetter()
        
        if let url = URL(string: plate.featuredImage ?? "") {
            let resource: ImageResource = ImageResource(downloadURL: url, cacheKey: plate.featuredImage ?? "")
            cell.ivFeatureImage.kf.setImage(with: resource)
        }
        
        //        let url = plate.featuredImage ?? "?"
        //        cell.ivFeatureImage.kf.setImage(with: URL(string: url))
        cell.uivFeaturedImageContainer.elevate(elevation: 5, cornerRadius: 15)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onPress?(plateList[indexPath.row])
    }
    
}
