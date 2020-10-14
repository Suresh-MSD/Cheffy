//
//  UserProfileService.swift
//  chef
//
//  Created by Eddie Ha on 28/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserProfileService: NSObject{

    public let CLASS_NAME = UserProfileService.self.description()
    private static var shared:UserProfileService!
    
    //get shared instance
    public static func getInstance() -> UserProfileService {
        if shared == nil {
            shared = UserProfileService()
        }
        
        return shared
    }
    
    
    //get user shipping address request
    public func getUserShippingAddress(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    //get user shipping address request
    public func getUserCard(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    /// Post user shipping address request
    public func postUserShippingAddress(url: String, parameters: [String: Any], completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let headers = [
            "Content-Type":"application/json",
            "x-access-token": Helper.getUserToken()
        ]
        let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        request.responseJSON(completionHandler: completionHandler)
    }
    
    /// Edit user shipping address request
    public func EditUserShippingAddress(url: String, parameters: [String: Any], completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let headers = [
            "Content-Type":"application/json",
            "x-access-token": Helper.getUserToken()
        ]
        let request = Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        request.responseJSON(completionHandler: completionHandler)
    }
    
    public func getUserProfile(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    public func setdefalutAddress(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["x-access-token": Helper.getUserToken()]
        
        Alamofire.request(url, method: .put, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    public func updateUserProfile(url:String, params: [String: Any] , completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        
        Alamofire.request(url, method: .put, parameters: params ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    public func UploadProfilePhoto(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((Data?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            let timeStamp = Date().ticks
            
            if let data = imageData{
                multipartFormData.append(data, withName: "profile_photo", fileName: "\(timeStamp).png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: endUrl, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(response.data)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    public func DeleteAddress(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type" : "application/json","x-access-token": Helper.getUserToken()]
        
        Alamofire.request(url, method: .delete, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
}
