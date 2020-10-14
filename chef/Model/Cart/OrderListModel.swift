//
//  OrderListModel.swift
//  chef
//
//  Created by Bola Ibrahim on 11/17/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation



// MARK: - Datum
struct OrderData: Codable {
    let id, datumBasketID, datumUserID, shippingID: Int?
    let stateType: String?
    let totalItens: Int?
    let shippingFee: Int?
    let orderTotal: Int?
    let createdAt, updatedAt: String?
    let basketID, userID: Int?
    let orderPayments: [OrderPayment]?
    let orderItems: [OrderItem]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case datumBasketID = "basketId"
        case datumUserID = "userId"
        case shippingID = "shippingId"
        case stateType = "state_type"
        case totalItens = "total_itens"
        case shippingFee = "shipping_fee"
        case orderTotal = "order_total"
        case createdAt, updatedAt
        case basketID = "BasketId"
        case userID = "UserId"
        case orderPayments = "OrderPayments"
        case orderItems = "OrderItems"
    }
}

// MARK: - OrderItem
struct OrderItem: Codable {
    let plateID: Int?
    let chefLocation, name, orderItemDescription: String?
    let amount, quantity: Int?
    let plate: Plate?
    
    enum CodingKeys: String, CodingKey {
        case plateID = "plate_id"
        case chefLocation = "chef_location"
        case name
        case orderItemDescription = "description"
        case amount, quantity, plate
    }
}

// MARK: - Plate
struct CartItemData: Codable {
    let id: Int?
    let name, plateDescription: String?
    let price: Double?
    let deliveryTime, sellCount: Int?
    let deliveryType: String?
    let plateUserID, categoryID, rating: Int?
    let createdAt, updatedAt: String?
    let userID: Int?
    let chef: ChefData?

    enum CodingKeys: String, CodingKey {
        case id, name
        case plateDescription = "description"
        case price
        case deliveryTime = "delivery_time"
        case sellCount = "sell_count"
        case deliveryType = "delivery_type"
        case plateUserID = "userId"
        case categoryID = "categoryId"
        case rating, createdAt, updatedAt
        case userID = "UserId"
        case chef
    }
}

// MARK: - Chef
struct ChefData: Codable {
    let id: Int?
    let name, email, countryCode: String?
    let phoneNo, authToken: String?
    let restaurantName, password, location, userType: String?
    let imagePath, verificationCode: String?
    let verificationEmailToken, verificationEmailStatus: String?
    let verificationPhoneToken: String?
    let verificationPhoneStatus: String?
    let status, userIP: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case countryCode = "country_code"
        case phoneNo = "phone_no"
        case authToken = "auth_token"
        case restaurantName = "restaurant_name"
        case password, location
        case userType = "user_type"
        case imagePath
        case verificationCode = "verification_code"
        case verificationEmailToken = "verification_email_token"
        case verificationEmailStatus = "verification_email_status"
        case verificationPhoneToken = "verification_phone_token"
        case verificationPhoneStatus = "verification_phone_status"
        case status
        case userIP = "user_ip"
        case createdAt, updatedAt
    }
}

// MARK: - OrderPayment
struct OrderPayment: Codable {
    let paymentID: String?
    let amount: Int?
    let clientSecret, customer, paymentMethod, status: String?
    
    enum CodingKeys: String, CodingKey {
        case paymentID = "payment_id"
        case amount
        case clientSecret = "client_secret"
        case customer
        case paymentMethod = "payment_method"
        case status
    }
}
