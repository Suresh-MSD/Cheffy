//
//  CartTabTrackingOrderCell.swift
//  chef
//
//  Created by Eddie Ha on 19/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

//MARK: Protocols
//CartTrackingOrderTabDetailsCellDelegate
protocol CartTrackingOrderTabDetailsCellDelegate: NSObjectProtocol {
    func onTapTrackingCartItem()
}


class CartTrackingOrderTabDetailsCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = CartTrackingOrderTabDetailsCell.self.description()
    open var delegate:CartTrackingOrderTabDetailsCellDelegate!
    open var trackingCartItemList = [CartItem](){
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
        cvCartList?.register(UINib(nibName: "CartTrackingCustomOrderCell", bundle: nil), forCellWithReuseIdentifier: "CartTrackingCustomOrderCell")
    }
    
}


//MARK: Extension
//MARK: CollectionView
extension CartTrackingOrderTabDetailsCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if trackingCartItemList.isEmpty{
            collectionView.setEmptyMessage("Tracking orders appear here")
        }else{
            collectionView.restore()
        }
        return trackingCartItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for tab bar cell
        return CGSize(width: cvCartList.frame.width, height: 150)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for first  cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartTrackingCustomOrderCell", for: indexPath) as! CartTrackingCustomOrderCell
        
        cell.uivContainer.elevate(elevation: 15, cornerRadius: 0, color : ColorGenerator.UIColorFromHex(rgbValue: 0x000000, alpha: 0.3))
        
        let trackingOrder = trackingCartItemList[indexPath.row]
        cell.lblTitle.text = trackingOrder.name
        cell.lblPrice.text = "$\(trackingOrder.price ?? 0)"
        
        if let imageUrl = trackingOrder.featuredImage {
            cell.ivFoodImage.setImageFromUrl(url: imageUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            delegate.onTapTrackingCartItem()
        }
    }
    


}
