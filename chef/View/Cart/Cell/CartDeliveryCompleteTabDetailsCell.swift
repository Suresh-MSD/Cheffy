//
//  CartDeliveryCompleteTabDetailsCell.swift
//  chef
//
//  Created by Eddie Ha on 19/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CartDeliveryCompleteTabDetailsCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = CartDeliveryCompleteTabDetailsCell.self.description()
    open var deliveryCompleteCartItemList = [CartItem](){
        didSet{
            self.cvCartList.reloadData()
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var cvCartList: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialization()
    }
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvCartList.delegate = self
        cvCartList.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        //        layout.itemSize = CGSize(width: (cvTabBar.frame.width/2)-15, height: (cvTabBar.frame.width/2)-15)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        cvCartList.collectionViewLayout = layout
        
        //Register cell
        cvCartList?.register(UINib(nibName: "CartDeliveryCompleteCell", bundle: nil), forCellWithReuseIdentifier: "CartDeliveryCompleteCell")
    }
    
}


//MARK: Extension
//MARK: CollectionView
extension CartDeliveryCompleteTabDetailsCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if deliveryCompleteCartItemList.isEmpty{
            collectionView.setEmptyMessage("Delivery orders appear here")
        }else{
            collectionView.restore()
        }
        
        return deliveryCompleteCartItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for tab bar cell
        return CGSize(width: cvCartList.frame.width, height: 130)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for first  cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartDeliveryCompleteCell", for: indexPath) as! CartDeliveryCompleteCell
        
        cell.uivContainer.elevate(elevation: 15, cornerRadius: 0, color : ColorGenerator.UIColorFromHex(rgbValue: 0x000000, alpha: 0.3))
        
        let deliveryCompleteOrder = deliveryCompleteCartItemList[indexPath.row]
        cell.lblTitle.text = deliveryCompleteOrder.name
        cell.lblPrice.text = "$\(deliveryCompleteOrder.price ?? 0)"
        
        if let imageUrl = deliveryCompleteOrder.featuredImage {
            cell.ivFoodImage.setImageFromUrl(url: imageUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

}
