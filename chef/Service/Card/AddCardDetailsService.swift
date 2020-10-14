//
//  AddCardDetailsService.swift
//  chef
//
//  Created by MJ on 13/01/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class AddCardDetailsService: NSObject {
    
    public let CLASS_NAME = AddCardDetailsService.self.description()
    private static var shared:AddCardDetailsService!
    
    //get shared instance
    public static func getInstance() -> AddCardDetailsService {
        if shared == nil {
            shared = AddCardDetailsService()
        }
        return shared
    }
    
    // add card request
    public func addCardRequest(url:String, parameters:[String:Any], completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
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
    
    public func DeleteCard(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type" : "application/json","x-access-token": Helper.getUserToken()]
        
        Alamofire.request(url, method: .delete, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
}
