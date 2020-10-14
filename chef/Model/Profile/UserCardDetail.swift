import Foundation
import UIKit

class UserCardDetail: Codable {
    open var id:String?
    open var object:String?
    open var billing_details:BillingDetails?
    open var address:Address?
    open var card:UserCard?
    open var checks:UserCardChecks?
    open var three_d_secure_usage:UserCardChecks_3D?
    open var created:Int?
    open var customer:String?
    open var livemode:Bool?
    open var type:String?
}

class BillingDetails: Codable {
    open var email:String?
    open var name:String?
    open var phone:String?
}

class Address: Codable {
    open var city:String?
    open var country:String?
    open var line1:String?
    open var line2:String?
    open var postal_code:String?
    open var state:String?
}

class UserCard: Codable {
    open var brand:String?
    open var country:String?
    open var exp_month:Int?
    open var exp_year:Int?
    open var fingerprint:String?
    open var funding:String?
    open var generated_from:String?
    open var last4:String?
    open var wallet:String?
}

class UserCardChecks: Codable {
    open var address_line1_check:String?
    open var address_postal_code_check:String?
    open var cvc_check:String?
}

class UserCardChecks_3D: Codable {
    open var supported:Bool?
}
