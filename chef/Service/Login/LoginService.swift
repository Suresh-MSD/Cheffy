//
//  LoginService.swift
//  chef
//
//  Created by Oluha group on 14/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class LoginService: NSObject {
    
    public let CLASS_NAME = LoginService.self.description()
    
    struct LoginParams {
        var phoneNumber: String
        var password: String
    }
    
    public static func loginRequest(
        params: LoginParams,
        completionHandler:@escaping ((result: ProfileItem?, error:String?)) -> Void)-> Void {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ProgressViewHelper.hide()
            let loginUser = ProfileItem()
            loginUser.id = "id0000"
            loginUser.name = "Ryohlan"
            loginUser.image = "https://avatars0.githubusercontent.com/u/2921712?s=460&v=4"
            loginUser.type = ""

            completionHandler((loginUser, nil))
        }
    }
}
