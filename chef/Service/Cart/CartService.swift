//
//  CartService.swift
//  chef
//
//  Created by Eddie Ha on 24/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class CartService: NSObject {
    public let CLASS_NAME = CartService.self.description()
    private static var shared:CartService!
    
    //get shared instance
    public static func getInstance() -> CartService {
        if shared == nil {
            shared = CartService()
        }
        return shared
    }
    
    //plate add to cart request
    public func addPlateToCartRequest(url:String, parameters:[String:Any], completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        
        print(headers)
        print(parameters)
        
        guard let url = URL(string: url) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters as Any, options: .prettyPrinted)
        
        Alamofire.request(url, method: .post, parameters: parameters ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    
    //get cart item list  request
    public func getCartItemListRequest(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["x-access-token": Helper.getUserToken()]
        
        print(headers)
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }

    //change basket item list request
    public func changeBasketCountRequest(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {

        let headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]

        Alamofire.request(url, method: .put, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in

            completionHandler(response)
        }
    }

    //delte basket request
    public func deleteBasketRequest(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {

        let headers = ["x-access-token": Helper.getUserToken()]

        Alamofire.request(url, method: .delete, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in

            completionHandler(response)
        }
    }
}


struct BasketRequest: RequestType {
    
    typealias Response = BasketModel
    var path: String { return "basket" }
    let headers = ["x-access-token": Helper.getUserToken()]
    var method: HTTPMethod { return .get }

}

struct CheckOutReuest: RequestType {
    struct Res: Codable {
        var message: String?
    }
    
    typealias Response = CheckOutReuest.Res
    var path: String { return "order" }
    let headers = ["x-access-token": Helper.getUserToken()]
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "deliveryType": self.deliveryType] }
    
    var deliveryType: String
}





