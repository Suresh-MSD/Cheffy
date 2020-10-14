//
//  CartService.swift
//  chef
//
//  Created by Eddie Ha on 24/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class FoodCategoryService: NSObject {
    public let CLASS_NAME = FoodCategoryService.self.description()
    private static var shared:FoodCategoryService!
    
    //get shared instance
    public static func getInstance() -> FoodCategoryService {
        if shared == nil {
            shared = FoodCategoryService()
        }
        return shared
    }
    
 
    //get cart item list  request
    public func getRequest(url:String,params : Parameters = [:], completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        var headers = ["Content-Type":"application/json"]
        
        if Helper.isLoggedIn(){
            headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        }
        print("usertoken",Helper.getUserToken())
        Alamofire.request(url, method: .get, parameters: params.isEmpty ? nil : params ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    
}

