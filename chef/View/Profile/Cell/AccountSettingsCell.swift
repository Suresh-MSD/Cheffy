//
//  AccountSettingsCell.swift
//  chef
//
//  Created by Eddie Ha on 29/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class AccountSettingsCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = AccountSettingsCell.self.description()
    
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var ivMenuIcon: UIImageView!
    @IBOutlet weak var lblMenuTitle: UILabel!
    
    @IBOutlet weak var img_width_contraint: NSLayoutConstraint!
    @IBOutlet weak var spacing_constraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
