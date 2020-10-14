//
//  DeliveryService.swift
//  chef
//
//  Created by Eddie Ha on 28/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class DeliveryService: NSObject {
    public let CLASS_NAME = DeliveryService.self.description()
    private static var shared:DeliveryService!
    
    //get shared instance
    public static func getInstance() -> DeliveryService {
        if shared == nil {
            shared = DeliveryService()
        }
        
        return shared
    }
    
    
    //get delivery details request
    public func getDeliveryDetailsRequest(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
}
