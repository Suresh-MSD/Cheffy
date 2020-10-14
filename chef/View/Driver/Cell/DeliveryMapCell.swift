//
//  HomeMapCell.swift
//  cheffydriver
//
//  Created by Eddie Ha on 3/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import MapKit

class DeliveryMapCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = DeliveryMapCell.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var mvRouteDirection: MKMapView!
    @IBOutlet weak var btnMapFloating: UIButton!
    @IBOutlet weak var swOnlineOffline: UISwitch!
    @IBOutlet weak var lblOnlineOffline: UILabel!
    @IBOutlet weak var uibOnlineOffline: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uibOnlineOffline.elevate(elevation: 10, cornerRadius: 0)
        swOnlineOffline.transform = CGAffineTransform(scaleX: 1.0, y: 0.90)
    }

    //MARK: Actions
    //on value change of online offline switch controller
    @IBAction func onClickOnlineOfflineSwitch(_ sender: UISwitch) {
    }
    
    
}
