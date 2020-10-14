//
//  PopularFoodListCell.swift
//  chef
//
//  Created by Eddie Ha on 20/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher

class PopularFoodListCell: UICollectionViewCell {
    
    //MARK: Properties
    public let CLASS_NAME = PopularFoodListCell.self.description()
//    public var foodList:[Food]!
    
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
        // Initialization code
        initialization()
    }
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvFoodList.delegate = self
        cvFoodList.dataSource = self
        
        //set collection view cell item cell
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: cvFoodList.frame.width, height: 300)
//        layout.minimumInteritemSpacing = 15
//        layout.minimumLineSpacing = 15
//        layout.scrollDirection = .horizontal
//        cvFoodList.collectionViewLayout = layout
        
        //cell for food list collection view
        let nibForFoodItemCell = UINib(nibName: "FoodItemCell", bundle: nil)
        cvFoodList?.register(nibForFoodItemCell, forCellWithReuseIdentifier: "FoodItemCell")
    }

}


//MARK: Extension
//MARK: CollectionView
extension PopularFoodListCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if plateList.isEmpty{
            collectionView.setEmptyMessage("No plates available")
        }else{
            collectionView.restore()
        }
        return plateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvFoodList.frame.width - 70, height: 240)
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
