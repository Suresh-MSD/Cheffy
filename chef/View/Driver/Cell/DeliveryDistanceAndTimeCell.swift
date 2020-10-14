//
//  HomeDistanceAndTimeCell.swift
//  cheffydriver
//
//  Created by Eddie Ha on 3/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import MBCircularProgressBar


class DeliveryDistanceAndTimeCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = DeliveryDistanceAndTimeCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var lblDeliveryBy: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var uivCircularProgressbar: MBCircularProgressBarView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   
    }

    //initialize circular progressbar
    public func initializeCircularProgressbar(progress: CGFloat) -> Void {
        uivCircularProgressbar.value = 0 
        UIView.animate(withDuration: 0.4, animations: {
            self.uivCircularProgressbar.value = progress
        })
    }
}
