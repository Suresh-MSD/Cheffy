//
//  CategoryService.swift
//  chef
//
//  Created by Eddie Ha on 16/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class CategoryService: NSObject {

    public let CLASS_NAME = CategoryService.self.description()
    private static var shared:CategoryService!
    
    //get shared instance
    public static func getInstance() -> CategoryService {
        if shared == nil {
            shared = CategoryService()
        }
        
        return shared
    }
    
    //get category list  request
    public func getCategoryListRequest(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json"]
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    
    //plate list by category  request
    public func plateListByCategoryRequest(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json"]
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
}

/*struct FoodCategeoryRequest: RequestType {
    
    typealias Response = [FoodCategory]
    var path: String { return "category" }
    var method: HTTPMethod { return .get }
}*/

struct FoodCategeoryListRequest: RequestType {
    
    typealias Response = [Plate]
    var path: String { return "category/\(categeoryId)/plates" }
    var method: HTTPMethod { return .get }
    
    var categeoryId: Int
}
