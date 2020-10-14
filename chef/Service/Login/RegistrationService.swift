//
//  RegistrationService.swift
//  chef
//
//  Created by Eddie Ha on 14/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationService: NSObject {

    public let CLASS_NAME = RegistrationService.self.description()
    
    //register user request
    public static func registrationRequest(url:String, params: [String: Any], completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        Alamofire.request(url, method: .post, parameters: params ,encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
}
