//
//  CartAddTabDetailsCell.swift
//  chef
//
//  Created by Eddie Ha on 17/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

protocol CartAddTabDetailsCellDelegate {

    func increase(basketId: Int)
    func decrease(basketId: Int)
    func delete(basketId: Int)
}

class CartAddTabDetailsCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = CartAddTabDetailsCell.self.description()
    public var delegate: CartAddTabDetailsCellDelegate?
    open var addcartItemList = [BasketItem](){
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
        cvCartList?.register(UINib(nibName: "CartAddInnerCell", bundle: nil), forCellWithReuseIdentifier: "CartAddInnerCell")
    }

}


//MARK: Extension
//MARK: CollectionView
extension CartAddTabDetailsCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if addcartItemList.isEmpty{
            collectionView.setEmptyMessage("Foods in cart appear here")
        }else{
            collectionView.restore()
        }
        
        return addcartItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for tab bar cell
        return CGSize(width: cvCartList.frame.width, height: 130)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for first  cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartAddInnerCell", for: indexPath) as! CartAddInnerCell
        
        cell.uivContainer.elevate(elevation: 15, cornerRadius: 0, color : ColorGenerator.UIColorFromHex(rgbValue: 0x000000, alpha: 0.3))
        cell.delegate = self
        
        let addCartOrder = addcartItemList[indexPath.row]
        cell.configureBasketCell(basket: addCartOrder, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension CartAddTabDetailsCell: CartAddInnerCellDelegate {

    func increaseItem(at: IndexPath) {
        let cartOder = addcartItemList[at.row]
        guard let id = cartOder.basketItemId else {
            return
        }
        delegate?.increase(basketId: id)
    }

    func decreaseItem(at: IndexPath) {
        let cartOder = addcartItemList[at.row]
        guard let id = cartOder.basketItemId else {
            return
        }
        delegate?.decrease(basketId: id)
    }

    func delete(at: IndexPath) {
        let cartOder = addcartItemList[at.row]
        guard let id = cartOder.basketItemId else {
            return
        }
        delegate?.delete(basketId: id)
    }
}
