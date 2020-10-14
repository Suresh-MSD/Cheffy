//
//  ChefDetailsInnerTabCell.swift
//  chef
//
//  Created by Eddie Ha on 25/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

//MARK: Protocols
//ChefDetailsNestedTabDetailsCellDelegate
protocol ChefDetailsNestedTabDetailsCellDelegate :NSObjectProtocol {
    func onClickViewAllReceipt()
}


class ChefDetailsNestedTabDetailsCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = ChefDetailsNestedTabDetailsCell.self.description()
    open var delegate:ChefDetailsNestedTabDetailsCellDelegate!
    open var plate = Plate(){
        didSet{
            self.lblDescription.text = self.plate.plateDescription
            
            if self.plate.ingredientList?.count ?? 0 > 2{
                self.lblIngredientOne.text = self.plate.ingredientList?[0].name ?? ""
                self.lblPurchaseDateOne.text = self.plate.ingredientList?[0].purchase_date ?? ""
                self.lblIngredientTwo.text = self.plate.ingredientList?[1].name ?? ""
                self.lblPurchaseDateTwo.text = self.plate.ingredientList?[1].purchase_date ?? ""
                self.lblIngredientThree.text = self.plate.ingredientList?[2].name ?? ""
                self.lblPurchaseDateThree.text = self.plate.ingredientList?[2].purchase_date ?? ""
            }
            
            if self.plate.ingredientList?.count ?? 0 > 1{
                self.lblIngredientOne.text = self.plate.ingredientList?[0].name ?? ""
                self.lblPurchaseDateOne.text = self.plate.ingredientList?[0].purchase_date ?? ""
                self.lblIngredientTwo.text = self.plate.ingredientList?[1].name ?? ""
                self.lblPurchaseDateTwo.text = self.plate.ingredientList?[1].purchase_date ?? ""
            }
            
            if self.plate.ingredientList?.count ?? 0 == 1{
               self.lblIngredientOne.text = "1. \(self.plate.ingredientList?[0].name ?? "")"
                self.lblPurchaseDateOne.text = self.plate.ingredientList?[0].purchase_date ?? ""
            }
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblIngredientOne: UILabel!
    @IBOutlet weak var lblIngredientTwo: UILabel!
    @IBOutlet weak var lblIngredientThree: UILabel!
     @IBOutlet weak var lblPurchaseDateOne: UILabel!
     @IBOutlet weak var lblPurchaseDateTwo: UILabel!
     @IBOutlet weak var lblPurchaseDateThree: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    //MARK: Actions
    @IBAction func onClickViewAllButton(_ sender: UIButton) {
        if delegate != nil {
            delegate.onClickViewAllReceipt()
        }
    }
    
}


