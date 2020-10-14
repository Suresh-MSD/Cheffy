//
//  User.swift
//  chef
//
//  Created by Oluha group on 2019/10/03.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

struct ErrorModel: Codable {
    var message: String?
}

struct UserModel: Codable {
    var message: String?
    var token: String?
    var data: User?
}

struct User: Codable {
    var id : Int?
    var name: String?
    var email: String?
    var country_code: String?
    var phone_no: String?
    var auth_token: String?
    var restaurant_name: String?
    var password: String?
    var password_generated: Bool?
    var location_lat: String?
    var location_lon: String?
    var user_type: UserType?
    var imagePath: String?
    var verification_code: String?
    var verification_email_token: String?
    var verification_email_status: VerificationEmailStatus?
    var verification_phone_token: String?
    var verification_phone_status: VerificationPhoneStatus?
    var status: Int?
    var user_ip: String?
    var stripe_id: String?
    var defaultAddress: String?
}

enum UserType: String, Codable {
    case user
    case chef
    case admin
    case driver
}

enum VerificationEmailStatus: String, Codable {
    case pending
    case verified
}

enum VerificationPhoneStatus: String, Codable {
    case pending
    case verified
}

struct Chef: Codable {
    var id: Int
    var name: String
    var email: String
    var country_code: Double?
    var phone_no: String?
    var auth_token: String?
    var restaurant_name: String?
    var password: String?
    var location_lat: String?
    var location_lon: String?
    var user_type: UserType
    var imagePath: String?
    var verification_code: String?
    var verification_email_token: String?
    var verification_email_status: String?
    var verification_phone_token: String?
    var verification_phone_status: String?
    var status: String?
    var user_ip: String?
    var stripe_id: String?
    var createdAt: String
    var updatedAt: String
    
}
