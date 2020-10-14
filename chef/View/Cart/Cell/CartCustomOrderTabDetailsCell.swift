//
//  CartTabCustomOrderDetailsCell.swift
//  chef
//
//  Created by Eddie Ha on 19/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CartCustomOrderTabDetailsCell: UICollectionViewCell {
    
    //MARK: Properties
    public let CLASS_NAME = CartCustomOrderTabDetailsCell.self.description()
    open var customOrderCartItemList = [CartItem](){
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
        cvCartList?.register(UINib(nibName: "CartCustomOrderCell", bundle: nil), forCellWithReuseIdentifier: "CartCustomOrderCell")
    }
    
}

//MARK: Extension
//MARK: CollectionView
extension CartCustomOrderTabDetailsCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if customOrderCartItemList.isEmpty{
            collectionView.setEmptyMessage("Coustom orders appear here")
        }else{
            collectionView.restore()
        }
        return customOrderCartItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for tab bar cell
        return CGSize(width: cvCartList.frame.width, height: 130)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for first  cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartCustomOrderCell", for: indexPath) as! CartCustomOrderCell
        
        cell.uivContainer.elevate(elevation: 15, cornerRadius: 0, color : ColorGenerator.UIColorFromHex(rgbValue: 0x000000, alpha: 0.3))
        
        let customOrder = customOrderCartItemList[indexPath.row]
        cell.lblTitle.text = customOrder.name
//        cell.lblTitle.text = "$\(customOrder.price ?? 0)"
        
        if let imageUrl = customOrder.featuredImage {
            cell.ivFoodImage.setImageFromUrl(url: imageUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

}
