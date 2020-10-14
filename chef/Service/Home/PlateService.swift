//
//  PlateService.swift
//  chef
//
//  Created by Eddie Ha on 22/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire

class PlateService: NSObject {
    
    public let CLASS_NAME = PlateService.self.description()
    private static var shared:PlateService!
    
    //get shared instance
    public static func getInstance() -> PlateService {
        if shared == nil {
            shared = PlateService()
        }
        
        return shared
    }
    
    //get plate list  request
    public func getPlateListRequest(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json"]
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    //get plate details  request
    public func getPlatedetailsRequest(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json"]
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    //get related plate list  request
    public func getRelatedPlateListRequest(url:String, completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json"]
        
        Alamofire.request(url, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    //plate add to cart   request
    public func addPlateToCartRequest(url:String, parameters:[String:Any], completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json"]
        
        Alamofire.request(url, method: .post, parameters: parameters ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    
    // create custom order request
    public func createCustomOrderRequest(url:String, parameters:[String:Any], imagesData: [Data], completionHandler: @escaping (DataResponse<Any>) -> Void) -> Void {
        
        let headers = ["Content-Type":"application/json", "x-access-token": Helper.getUserToken()]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for i in 0...imagesData.count-1 {
                multipartFormData.append(imagesData[i], withName: "order_image[\(i)]", fileName: "order_image_\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append(((value as? String) ?? "").data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    completionHandler(response)
                }
            case .failure(let error):
                print("\(self.CLASS_NAME) -- createCustomOrderRequest() -- error = \(error)")
            }
            
        })
    }
    
    //create custom plate  request
    public func createCustomPlateRequest(url:String, parameters:[String:Any], completionHandler: @escaping (DataResponse<Any>) -> Void)-> Void {
        
        let headers = ["Content-Type":"application/json", "x-access-token":Helper.getUserToken()]
        
        Alamofire.request(url, method: .post, parameters: parameters ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            completionHandler(response)
        }
    }
    
    public func postReviewRequest(url: String, parameters: [String:Any], completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let headers = [
            "Content-Type":"application/json",
            "x-access-token": Helper.getUserToken()
        ]
        let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        request.responseJSON(completionHandler: completionHandler)
    }
    
    public func postAddFavouriteRequest(url: String, parameters: [String:Any], completionHandler: @escaping (DataResponse<String>) -> Void) {
        let headers = [
            "Content-Type":"application/json",
            "x-access-token": Helper.getUserToken()
        ]
        let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        //        request.responseJSON(completionHandler: completionHandler)
        request.responseString(completionHandler: completionHandler)
    }
    
    public func postRemoveFavouriteRequest(url: String, completionHandler: @escaping (DataResponse<String>) -> Void) {
        let headers = [
            "Content-Type":"application/json",
            "x-access-token": Helper.getUserToken()
        ]
        let request = Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        //        request.responseJSON(completionHandler: completionHandler)
        request.responseString(completionHandler: completionHandler)
    }
}

struct CreateCustomPlateRequest: RequestType {
    
    struct Res: Codable {
        var message: String?
    }
    
    typealias Response = CreateCustomPlateRequest.Res
    var path: String { return "custom-plate" }
    let headers = ["x-access-token": Helper.getUserToken()]
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] {
        return [
            "name": self.name,
            "description": self.description,
            "price_min": self.minPrice,
            "price_max": self.maxPrice,
            "quantity": self.quantity,
            "images": self.images,
            "close_date": self.closeDate
        ]
    }
    
    var name: String
    var description: String
    var minPrice: Int
    var maxPrice: Int
    var quantity: Int
    var images: [NSMutableDictionary]
    var closeDate: Date
}
