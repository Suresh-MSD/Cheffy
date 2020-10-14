
//
//  AppDelegate.swift
//  LyfteD Driver
//
//  Created by jignesh kasundra on 13/12/19.
//  Copyright © 2019 jignesh kasundra. All rights reserved.

import Foundation


class FavouriteCustomPlate : NSObject, NSCoding{

	var customPlateImages : [FavouriteCustomPlateImage]!
	var closeDate : String!
	var createdAt : String!
	var descriptionField : String!
	var id : Int!
	var name : String!
	var priceMax : Int!
	var priceMin : Int!
	var quantity : Int!
	var updatedAt : String!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    
	init(fromDictionary dictionary: [String:Any]){
		customPlateImages = [FavouriteCustomPlateImage]()
		if let customPlateImagesArray = dictionary["CustomPlateImages"] as? [[String:Any]]{
			for dic in customPlateImagesArray{
				let value = FavouriteCustomPlateImage(fromDictionary: dic)
				customPlateImages.append(value)
			}
		}
		closeDate = dictionary["close_date"] as? String
		createdAt = dictionary["createdAt"] as? String
		descriptionField = dictionary["description"] as? String
		id = dictionary["id"] as? Int
		name = dictionary["name"] as? String
		priceMax = dictionary["price_max"] as? Int
		priceMin = dictionary["price_min"] as? Int
		quantity = dictionary["quantity"] as? Int
		updatedAt = dictionary["updatedAt"] as? String
		userId = dictionary["userId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
    
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if customPlateImages != nil{
			var dictionaryElements = [[String:Any]]()
			for customPlateImagesElement in customPlateImages {
				dictionaryElements.append(customPlateImagesElement.toDictionary())
			}
			dictionary["CustomPlateImages"] = dictionaryElements
		}
		if closeDate != nil{
			dictionary["close_date"] = closeDate
		}
		if createdAt != nil{
			dictionary["createdAt"] = createdAt
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		if priceMax != nil{
			dictionary["price_max"] = priceMax
		}
		if priceMin != nil{
			dictionary["price_min"] = priceMin
		}
		if quantity != nil{
			dictionary["quantity"] = quantity
		}
		if updatedAt != nil{
			dictionary["updatedAt"] = updatedAt
		}
		if userId != nil{
			dictionary["userId"] = userId
		}
		return dictionary
	}

    
//     NSCoding required initializer.
 
    @objc required init(coder aDecoder: NSCoder)
	{
         customPlateImages = aDecoder.decodeObject(forKey :"CustomPlateImages") as? [FavouriteCustomPlateImage]
         closeDate = aDecoder.decodeObject(forKey: "close_date") as? String
         createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         priceMax = aDecoder.decodeObject(forKey: "price_max") as? Int
         priceMin = aDecoder.decodeObject(forKey: "price_min") as? Int
         quantity = aDecoder.decodeObject(forKey: "quantity") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? Int

	}

//      NSCoding required method.
  
    @objc func encode(with aCoder: NSCoder)
	{
		if customPlateImages != nil{
			aCoder.encode(customPlateImages, forKey: "CustomPlateImages")
		}
		if closeDate != nil{
			aCoder.encode(closeDate, forKey: "close_date")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "createdAt")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if priceMax != nil{
			aCoder.encode(priceMax, forKey: "price_max")
		}
		if priceMin != nil{
			aCoder.encode(priceMin, forKey: "price_min")
		}
		if quantity != nil{
			aCoder.encode(quantity, forKey: "quantity")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updatedAt")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "userId")
		}

	}

}

class FavouriteCustomPlateImage : NSObject, NSCoding{

    var id : Int!
    var url : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        url = dictionary["url"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if url != nil{
            dictionary["url"] = url
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         id = aDecoder.decodeObject(forKey: "id") as? Int
         url = aDecoder.decodeObject(forKey: "url") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }

    }
}

