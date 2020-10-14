//
//  CartAddCell.swift
//  chef
//
//  Created by Eddie Ha on 18/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

protocol CartAddInnerCellDelegate {

    func increaseItem(at: IndexPath)
    func decreaseItem(at: IndexPath)
    func delete(at: IndexPath)
}

class CartAddInnerCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = CartAddInnerCell.self.description()
    public var amount = 0
    public var delegate: CartAddInnerCellDelegate?
    
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var uivContentView: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivFoodImage: UIImageView!
    @IBOutlet weak var QuantityView: UIView!
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureBasketCell(basket: BasketItem, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        self.lblTitle.text = basket.plate?.name
        self.lblPrice.text = "$\(basket.plate?.price ?? 0)"
        self.lblAmount.text = "\(basket.quantity ?? 0)"
        amount = basket.quantity ?? 0
        ivFoodImage.clipsToBounds = true
        QuantityView.layer.cornerRadius = QuantityView.frame.size.height / 2
        // there is no image in the response
//        if let imageUrl = basket.featuredImage {
//            self.ivFoodImage.setImageFromUrl(url: imageUrl)
//        }
    }
    
    //MARK: Actions
    //when tap on minus button
    @IBAction func onTapMinusButton(_ sender: UIButton) {
        if amount > 1 {
            amount -= 1
            lblAmount.text = "\(amount)"
            if let indexPath = indexPath {
                delegate?.decreaseItem(at: indexPath)
            }
        }
    }
    
    //when tap on Plus button
    @IBAction func onTapPlusButton(_ sender: UIButton) {
        
        amount += 1
        lblAmount.text = "\(amount)"
        if let indexPath = indexPath {
            delegate?.increaseItem(at: indexPath)
        }
    }
    
    //when tap on delete button
    @IBAction func onTapDeleteButton(_ sender: UIButton) {

        if let indexPath = indexPath {
            delegate?.delete(at: indexPath)
        }
    }
}
