//
//  UserProfileTopCell.swift
//  chef
//
//  Created by Eddie Ha on 28/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import CoreLocation

//MARK: Protocols
protocol UserProfileTopCellDelegate: NSObjectProtocol {
    func onClickChangeProfilePictureButton()
}

class UserProfileTopCell: UICollectionViewCell, LocationDelegate {
    
    //MARK: Properties
    public let CLASS_NAME = UserProfileTopCell.self.description()
    open var delegate:UserProfileTopCellDelegate!
    private var location: LocationService!
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    //MARK: Outlets
    override func awakeFromNib() {
        super.awakeFromNib()
        location = LocationService()
        location.delegate = self
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
    }
    
    //MARK: Actions
    @IBAction func onClickChangePictureButton(_ sender: UIButton) {
//        if delegate != nil{
//            delegate.onClickChangeProfilePictureButton()
//        }
    }

    func set(user: User) {
        if let url = user.imagePath {
            iconImage.setImageFromUrl(url: url)
            
        }else{
            //iconImage.backgroundColor = .lightGray
            iconImage.image = #imageLiteral(resourceName: "user_placeholder")
        }
        iconImage.backgroundColor = .clear
        nameLabel.text = user.name
        locationLabel.text = user.defaultAddress
    }
    
    func updateLocation(placemark: CLPlacemark) {
        var locationText = ""
        if let subThroughfare = placemark.subThoroughfare {
            locationText = locationText + " \(String(describing: subThroughfare))"
        }
        if let throughfare = placemark.thoroughfare {
            locationText = locationText + " \(String(describing: throughfare))"
        }
        if let locality = placemark.locality {
            locationText = locationText + " \(String(describing: locality))"
        }
        if let administrativeArea = placemark.administrativeArea {
            locationText = locationText + " \(String(describing: administrativeArea))"
        }
        self.locationLabel.text = locationText
        self.locationLabel.textColor = UIColor.gray
    }
}
