//
//  CartItem.swift
//  chef
//
//  Created by Eddie Ha on 19/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class CartItem: NSObject {
    
    open var id:Int?
    open var name:String?
    open var featuredImage:String?
    open var timeline:String?
    open var deliveryTime:Int?
    open var rating:Int?
    open var price:Int?
    open var actionType:String?
    open var category:String?
    open var cartItemType:String?
}

// MARK: - BasketModel
struct BasketModel: Codable {
    let subTotal, deliveryFee, total: Double?
    var items: [BasketItem]?
    
    enum CodingKeys: String, CodingKey {
        case subTotal = "sub_total"
        case deliveryFee = "delivery_fee"
        case total, items
    }
}

struct BasketItem: Codable {
    
    let basketItemId: Int?
    let quantity: Int?
    let totalValue: Double?
    let plate: BasketPlate?
    
    enum CodingKeys: String, CodingKey {
        case quantity
        case totalValue = "total_value"
        case plate
        case basketItemId
    }
}

// MARK: - Plate
struct BasketPlate: Codable {
    let id:Int?
    let name, plateDescription: String?
    let price: Double?
    let deliveryTime: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case plateDescription = "description"
        case price
        case deliveryTime = "delivery_time"
    }
}
