//
//  ApiManager.swift
//  chef
//
//  Created by Eddie Ha on 14/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

open class ApiManager: NSObject {
    public static let SERVER_BASE_URL:String = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String
    
    public static let API_VERSION = ""
}

enum HTTPHeaderField: String {
    case authentication = "x-access-token"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
