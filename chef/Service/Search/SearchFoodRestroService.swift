//
//  SearchFoodRestroService.swift
//  chef
//
//  Created by MJ on 07/01/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class SearchFoodRestroService: NSObject {
    public let CLASS_NAME = SearchFoodRestroService.self.description()
    private static var shared:SearchFoodRestroService!
    
    //get shared instance
    public static func getInstance() -> SearchFoodRestroService {
        if shared == nil {
            shared = SearchFoodRestroService()
        }
        return shared
    }
    
 
    //get cart item list  request
    public func getRequest(url:String,params : Parameters = [:], completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        var headers = ["Content-Type":"application/json"]
        
        if Helper.isLoggedIn(){
            headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        }
        Alamofire.request(url, method: .get, parameters: params.isEmpty ? nil : params ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
}
