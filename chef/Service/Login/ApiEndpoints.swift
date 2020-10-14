//
//  ApiEndpoints.swift
//  chef
//
//  Created by Eddie Ha on 14/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

open class ApiEndpoints: NSObject {
    //server base url
    private static let BASE_URL:String = ApiManager.SERVER_BASE_URL+ApiManager.API_VERSION
    
    //api endpoints
    //Registration and Login
    public static let URI_LOGIN:String = BASE_URL+"login"
    public static let URI_REGISTER_USER:String = BASE_URL+"user"
    
    //plate endpoints
    public static let URI_GET_PLATE_LIST:String = BASE_URL+"plate"
    public static let URI_GET_NEAR_PLATE_LIST:String = BASE_URL+"plate?near=true"
    public static let URI_GET_PLATE_DETAILS:String = BASE_URL+"plate/show"
    public static let URI_GET_PEOPLE_ADDED:String = BASE_URL+"user/peopleAlsoAdded"
    public static let URI_GET_POPULER_PLATE:String = BASE_URL+"plate/popular"
    public static let URI_POST_CUSTOM_PLATE:String = BASE_URL+"custom-plate"
    
    public static let URI_POST_ADD_FAVOURITE:String = BASE_URL+"favourite/add"
    public static let URI_GET_FAVOURITE_LIST:String = BASE_URL+"favourite/"
    public static let URI_POST_REMOVE_FAVOURITE:String = BASE_URL+"favourite/remove/"
    public static let URI_GET_SEARCH_FOOD_RESTRO:String = BASE_URL+"user/search/"
    
    //category endpoints
    public static let URI_GET_CATEGORY_LIST:String = BASE_URL+"category"
    public static let URI_GET_PLATE_LIST_BY_CATEGORY:String = BASE_URL+"plate/category"
    
    // Cart endpoints
    public static let URI_ADD_PLATE_TO_CART:String = BASE_URL+"basket"
    public static let URI_PUT_INCREASE_CART:String = BASE_URL+"basket/add"
    public static let URI_PUT_DECREASE_CART:String = BASE_URL+"basket/subtract"
    public static let URI_DELETE_CART:String = BASE_URL+"basket/delete"
    public static let URI_GET_ADD_CART_ITEM_LIST:String = BASE_URL+"order/list"
    public static let URI_GET_TRACKING_CART_ITEM_LIST:String = BASE_URL+"order/list/userTracking"
    public static let URI_GET_DELIVERY_COMPLETE_CART_ITEM_LIST:String = BASE_URL+"delivery/complete"
    
    //delivery endpoints
    public static let URI_GET_DELIVERY_DETAILS:String = BASE_URL+"delivery" 
    
    //user endpoints
    public static let URI_GET_USER_SHIPPING_ADRESS:String = BASE_URL+"shipping"
    public static let URI_POST_USER_SHIPPING_ADRESS:String = BASE_URL+"shipping"
    public static let URI_UPDATE_USER_SHIPPING_ADRESS:String = BASE_URL+"shipping"
    
    // order endpoints
    public static let URI_POST_ORDER_REVIEW:String = BASE_URL+"order"
    
   // Card endpoints
   public static let URI_POST_CARD_DETAILS:String = BASE_URL+"card"
    
    
    // Account   
    public static let URI_GET_USERPROFILE:String = BASE_URL+"user/"
    public static let URI_UPDATE_USERPROFILE:String = BASE_URL+"user/edit"
    public static let URI_UPLOAD_PROFILEPHOTO:String = BASE_URL+"docs/profilePhoto"
    
}
