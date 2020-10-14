//
//  PostOrderImageCell.swift
//  chef
//
//  Created by Eddie Ha on 11/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class PostOrderImageCell: UICollectionViewCell {

    //MARK: Propeties
    public let CLASS_NAME = PostOrderImageCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainerView: UIView!
    @IBOutlet weak var ivOrderImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
