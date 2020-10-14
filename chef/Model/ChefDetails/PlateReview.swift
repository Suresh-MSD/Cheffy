//
//  PlateReview.swift
//  chef
//
//  Created by Eddie Ha on 22/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class PlateReview: NSObject, Codable {
    var comment: String?
    var rating: String?
    var reviewdate: String?
    var user: User?
}


class AggregateReview: NSObject, Codable {
    
    var id: Int?
    var review_type: String?
    var chefID: Int?
    var driverID: Int?
    var plateId: Int?
    var userCount: Int?
    var rating: Double?
}
