//
//  RequestProtocol.swift
//  chef
//
//  Created by Oluha group on 2019/10/03.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestType {
    associatedtype Response
    associatedtype CustomResponse
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    func exec(completion: @escaping (_ result: Response?, _ error: String?) -> ())
}

extension RequestType where Response: Codable {
    typealias CustomResponse = Response
    var baseUrl: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String
     }
    var headers: [String : String] { return [:] }
    var method: HTTPMethod { return .get }
    var parameters: [String: Any] { return [:] }
    func exec(completion: @escaping (_ result: Response?, _ error: String?) -> ()) {
        
        debugPrint("✍🏻 Request URL >>>> " + self.baseUrl + self.path)
        debugPrint("✍🏻 Request Body >>>> " + String(describing: parameters))
        debugPrint("✍🏻 Request Method >>>> " + String(describing: method))
        debugPrint("✍🏻 Request Header >>>> " + String(describing: headers))

        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(self.baseUrl + self.path, method: self.method, parameters: self.parameters, headers: self.headers).responseString { response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if response.response?.statusCode == 500 {
                completion(nil, Helper.ErrorMessage)
            } else {
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        print(JSON)
                        debugPrint("✅ Respons Object >>>> " + String(describing: JSON))
                        do {
                            let result = try JSONDecoder().decode(Response.self, from: JSON.data(using: .utf8)!)
                            debugPrint("✍️ Result: " + String(describing: result))
                                completion(result, nil)
                        } catch let error { // mapping fail
                            debugPrint("❌ Error in Mapping" + String(describing: error) + self.baseUrl + self.path)
                            completion(nil, Helper.ErrorMessage)
                        }
                    }
                } else {
                    debugPrint("❌ 😝 Response fail : \(response.result.description)")
                    completion(nil, (response.result.error?.localizedDescription)!)
                }
            }
        }
    }
}

struct LoginRequest: RequestType {
    struct Res: Codable {
        var token: String?
        var data: User?
        var message: String?
    }

    typealias Response = LoginRequest.Res
    var path: String { return "user/login" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "login": self.login, "password": self.password] }

    var login: String
    var password: String
}

struct SignUpRequest: RequestType {
    struct Res: Codable {
        var result: User?
        var message: String?
    }

    typealias Response = SignUpRequest.Res
    var path: String { return "user/" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "email": self.email] }

    var email: String
}

struct SetUserPhoneNumber: RequestType {
    struct Res: Codable {
        var status: Int?
        var message: String?
        var code: Int?
        var moreInfo: Int?
    }

    typealias Response = SetUserPhoneNumber.Res
    var path: String { return "user/phone" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "country_code": self.country_code,"phone_no": self.phone_no] }
    var headers: [String : String] {
        return [ "Content-Type":  "application/json","x-access-token":  Helper.getUserToken()]
    }
    
    var country_code: String
    var phone_no: String
}

struct CodeVerificationRequest: RequestType {
    
    struct Res: Codable {
        var message: String?
        var status: Int?
    }

    typealias Response = CodeVerificationRequest.Res
    var path: String { return "user/verify-email-token" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "email": self.email, "email_token" : self.email_token] }

    var email: String
    var email_token: String
}

struct NamePasswordRequest: RequestType {
    
    struct Res: Codable {
        
        var message: String?
        var status: Int?
        var result: User?
    }

    typealias Response = NamePasswordRequest.Res
    var path: String { return "user/complete-registration" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "email": self.email,
                                              "name" : self.name,
                                              "password" : self.password,
                                              "user_type" : self.user_type,
                                              "restaurant_name" : self.restaurant_name,
                                              "promotionalContent" : self.promotionalContent] }

    var email: String
    var name: String
    var password: String
    var user_type: String
    var restaurant_name: String
    var promotionalContent: Bool
}

struct SocialSignUpRequest: RequestType {
    struct Res: Codable {
        
        var message: String?
        var status: Int?
        var result: User?
    }
    
    typealias Response = SocialSignUpRequest.Res
    var path: String { return "user/socialauth/register" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "email": self.email,
                                              "name" : self.name,
                                              "user_type" : self.user_type,
                                              "provider"  : self.provider,
                                              "provider_user_id":self.provider_user_id,
                                              "imagePath":self.imagePath] }
    
    var email: String
    var name: String
    var user_type: String
    var provider: String
    var provider_user_id: String
    var imagePath: String
    
}

struct SocialRequest: RequestType {
      
    struct Res: Codable {
        var token: String?
        var data: User?
        var message: String?
    }
    
    typealias Response = SocialRequest.Res
    var path: String { return "user/socialauth" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "email": self.email,
                                              "provider"  : self.provider,
                                              "provider_user_id":self.provider_user_id] }
    
    var email: String
    var provider: String
    var provider_user_id: String
}

struct ForgetPasswordRequest: RequestType {
    struct Res: Codable {
        var message: String?
        var status: Int?
    }

    typealias Response = ForgetPasswordRequest.Res
    var path: String { return "user/forgot-password" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "email": self.email] }

    var email: String
}


struct CodeVerificationForgetPasswordRequest: RequestType {
    
    struct Res: Codable {
        var message: String?
        var status: Int?
    }

    typealias Response = CodeVerificationForgetPasswordRequest.Res
    var path: String { return "user/verify-email-token-forgot-password" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "email": self.email, "email_token" : self.email_token] }

    var email: String
    var email_token: Int
}

struct NewResetPasswordRequest: RequestType {
    
    struct Res: Codable {
        var message: String?
        var status: Int?
    }

    typealias Response = NewResetPasswordRequest.Res
    var path: String { return "user/reset-password" }
    var method: HTTPMethod { return .post }
    var parameters: [String : Any] { return [ "email": self.email, "email_token" : self.email_token, "newPassword" : self.newPassword] }

    var email: String
    var email_token: Int
    var newPassword: String
}

struct OrderListRequest: RequestType {
    struct Res: Codable {
        let message: String?
        let data: [OrderData]?
    }
    
    typealias Response = OrderListRequest.Res
    var path: String { return "order/list" }
    var method: HTTPMethod { return .get }
    
    var headers: NSMutableDictionary {
        return [ HTTPHeaderField.authentication:  Helper.getUserToken()]
    }
}



struct NearPlateRequest: RequestType {
    struct Res: Codable {
        var userId: Double
        var distance: Double
        var plate_id: Int
        var delivery_type: String
        var name: String
        var imageURL: String
        var price: Double
        var description: String
        var delivery_time: Double
        var rating: Int
    }
    
    typealias Response = [NearPlateRequest.Res]
    var path: String { return "plate/near?latitude=\(self.latitude)&longitude=\(self.longitude)&radius=\(self.radius)" }
    
    var latitude: Double
    var longitude: Double
    var radius: Int
}

struct PopularPlateRequest: RequestType {
    
    struct Res: Codable {
        var message: String?
        var data: [PopularPlateType]?
    }
    
    typealias Response = [PopularPlateRequest.Res]
    var path: String { return "plate/popular" }
    var method: HTTPMethod { return .get }
    
    var headers: NSMutableDictionary {
        return [ HTTPHeaderField.authentication: Helper.getUserToken()]
    }
    
}

struct NewPlateRequest: RequestType {
    struct Image: Codable {
        var id: Int
        var name: String
        var url: String
    }
    
    struct Res: Codable {
        var id: Int
        var name: String
        var description: String
        var price: Double
        var delivery_time: Double
        var PlateImages: [Image]
    }
    
    typealias Response = [NewPlateRequest.Res]
    var path: String { return "plate" }
}

struct PlateDetailRequest: RequestType {

    struct Res: Codable {
        var message: String
        var data: PlateType
    }
    
    typealias Response = PlateDetailRequest.Res
    var path: String { return "plate/show/\(self.plateId)" }
    
    var plateId: Int
}


func plateFromPlateType(plateType: PlateType) -> Plate {
    let plate = Plate()
    plate.id = plateType.id
    plate.name = plateType.name
    plate.plateImageList = plateType.PlateImages
    plate.ingredientList = plateType.Ingredients
    plate.plateReviewList = plateType.reviews
    plate.plateDescription = plateType.description
    plate.featuredImage = plateType.PlateImages.first?.url
    plate.price = plateType.price
    plate.deliveryTime = plateType.delivery_time
    plate.rating = plateType.rating
    plate.category = plateType.category.name
    plate.chefId = String(plateType.chef.id)
    plate.chefProfilePictureUrl = plateType.chef.imagePath
    plate.chefName = plateType.chef.name
    plate.chefEmail = plateType.chef.email
    plate.chefPhoneNo = plateType.chef.phone_no
    return plate
}
