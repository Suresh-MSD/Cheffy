
//
//  AppDelegate.swift
//  LyfteD Driver
//
//  Created by jignesh kasundra on 13/12/19.
//  Copyright © 2019 jignesh kasundra. All rights reserved.

import Foundation


class FavouriteModel : NSObject, NSCoding {

	var data : [FavouriteData]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		data = [FavouriteData]()
		if let dataArray = dictionary["data"] as? [[String:Any]]{
			for dic in dataArray{
				let value = FavouriteData(fromDictionary: dic)
				data.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
    
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if data != nil{
			var dictionaryElements = [[String:Any]]()
			for dataElement in data {
				dictionaryElements.append(dataElement.toDictionary())
			}
			dictionary["data"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObject(forKey :"data") as? [FavouriteData]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
	}
}

class FavouriteData : NSObject, NSCoding{

    var customplateID : Int!
    var customplateId : Int!
    //var plate : AnyObject!
    var createdAt : String!
    var customPlates : FavouriteCustomPlate!
    var plate : FavouriteCustomPlate!
    var favType : String!
    var id : Int!
    var plateId : AnyObject!
    var updatedAt : String!
    var userId : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init(fromDictionary dictionary: [String:Any]){
        customplateID = dictionary["CustomplateID"] as? Int
        customplateId = dictionary["CustomplateId"] as? Int
        //plate = dictionary["Plate"] as? AnyObject
        createdAt = dictionary["createdAt"] as? String
        if let customPlatesData = dictionary["custom_plates"] as? [String:Any]{
            customPlates = FavouriteCustomPlate(fromDictionary: customPlatesData)
        }
        
        if let platesData = dictionary["Plate"] as? [String:Any]{
            plate = FavouriteCustomPlate(fromDictionary: platesData)
        }
        
        favType = dictionary["fav_type"] as? String
        id = dictionary["id"] as? Int
        plateId = dictionary["plateId"] as? AnyObject
        updatedAt = dictionary["updatedAt"] as? String
        userId = dictionary["userId"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if customplateID != nil{
            dictionary["CustomplateID"] = customplateID
        }
        if customplateId != nil{
            dictionary["CustomplateId"] = customplateId
        }
        if plate != nil{
            dictionary["Plate"] = plate
        }
        if createdAt != nil{
            dictionary["createdAt"] = createdAt
        }
        if customPlates != nil{
            dictionary["custom_plates"] = customPlates.toDictionary()
        }
        if favType != nil{
            dictionary["fav_type"] = favType
        }
        if id != nil{
            dictionary["id"] = id
        }
        if plateId != nil{
            dictionary["plateId"] = plateId
        }
        if updatedAt != nil{
            dictionary["updatedAt"] = updatedAt
        }
        if userId != nil{
            dictionary["userId"] = userId
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    
    
    @objc required init(coder aDecoder: NSCoder)
    {
         customplateID = aDecoder.decodeObject(forKey: "CustomplateID") as? Int
         customplateId = aDecoder.decodeObject(forKey: "CustomplateId") as? Int
         plate = aDecoder.decodeObject(forKey: "Plate") as? FavouriteCustomPlate
         createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
         customPlates = aDecoder.decodeObject(forKey: "custom_plates") as? FavouriteCustomPlate
         favType = aDecoder.decodeObject(forKey: "fav_type") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         plateId = aDecoder.decodeObject(forKey: "plateId") as? AnyObject
         updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    
    
    @objc func encode(with aCoder: NSCoder)
    {
        if customplateID != nil{
            aCoder.encode(customplateID, forKey: "CustomplateID")
        }
        if customplateId != nil{
            aCoder.encode(customplateId, forKey: "CustomplateId")
        }
        if plate != nil{
            aCoder.encode(plate, forKey: "Plate")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if customPlates != nil{
            aCoder.encode(customPlates, forKey: "custom_plates")
        }
        if favType != nil{
            aCoder.encode(favType, forKey: "fav_type")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if plateId != nil{
            aCoder.encode(plateId, forKey: "plateId")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
    }
}
