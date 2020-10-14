//
//  UserShippingAddress.swift
//  chef
//
//  Created by Eddie Ha on 28/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class UserShippingAddress: Codable {
    open var id:Int?
    open var userId:Int?
    open var addressLine1:String?
    open var addressLine2:String?
    open var city:String?
    open var lattitude:String?
    open var longitude:String?
    open var state:String?
    open var zipCode:String?
    open var isDefaultAddress:Bool?
    open var deliveryNote:String?
}
