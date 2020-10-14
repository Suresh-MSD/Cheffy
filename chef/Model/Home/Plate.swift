//
//  Plate.swift
//  chef
//
//  Created by Eddie Ha on 22/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class Plate: NSObject, Codable {
    open var id:Int?
    open var name:String?
    open var plateDescription:String?
    open var featuredImage:String?
    open var timeline:String?
    open var distance:String?
    open var deliveryType:String?
    open var price:Double?
    open var deliveryTime:Int?
    open var available:Bool?
    open var rating:Double?
    open var actionType:String?
    open var category:String?
    open var DietCategories:[DietCategoryInfo]?
    open var ingredientList:[Ingredient]?
    open var plateImageList:[PlateImage]?
    open var kitchenImageList:[KitchenImage]?
    open var receiptImageList:[ReceiptImage]?
    open var plateReviewList:[PlateReview]?
    open var AggregateReview:AggregateReview?
    
    open var chefId:String?
    open var chefName:String?
    open var chefEmail:String?
    open var chefPhoneNo:String?
    open var chefLocation:String?
    open var chefLocation_Lat:String?
    open var chefLocation_Lon:String?
    open var chefProfilePictureUrl:String?
    open var restaurantName:String?
    open var chefDeliveryAvailable:Bool?
    
}

struct PlateType: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var price: Double?
    var delivery_time: Int?
    var sell_count: Double?
    var rating: Double?
    var category: PlateCategory
    var Ingredients: [Ingredient]
    var PlateImages: [PlateImage]
    var KitchenImages: [KitchenImage]
    var ReceiptImages: [ReceiptImage]
    var reviews: [PlateReview]
    var chef: Chef
}

struct PopularPlateType: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var price: Double?
    var delivery_time: Int?
    var chefDeliveryAvailable: Bool?
    var userId: Int?
}

struct PlateCategory: Codable {
    var name: String?
    var description: String?
    var url: String?
}
