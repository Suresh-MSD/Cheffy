//
//  HomeViewController.swift
//  cheffydriver
//
//  Created by Eddie Ha on 3/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class DeliveryDetailsViewController: UIViewController {

    //MARK: Properties
    public let CLASS_NAME = DeliveryDetailsViewController.self.description()
    private var userShippingAddress = UserShippingAddress()
    private var chefShippingAddress = UserShippingAddress()
    
    //MARK: Outlets
    @IBOutlet weak var cvDriverInfo: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialization()
        getDeliveryDetails()
    }

    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvDriverInfo.delegate = self
        cvDriverInfo.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cvDriverInfo.frame.width, height: 500)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        cvDriverInfo.collectionViewLayout = layout
        cvDriverInfo.contentInset.top = -UIApplication.shared.statusBarFrame.height
        
        //cell for food list collection view
        cvDriverInfo?.register(UINib(nibName: "DeliveryDetailsMapCell", bundle: nil), forCellWithReuseIdentifier: "DeliveryDetailsMapCell")
        cvDriverInfo?.register(UINib(nibName: "DeliveryPickupDropoffCell", bundle: nil), forCellWithReuseIdentifier: "DeliveryPickupDropoffCell")
        cvDriverInfo?.register(UINib(nibName: "DeliveryDistanceAndTimeCell", bundle: nil), forCellWithReuseIdentifier: "DeliveryDistanceAndTimeCell")
        cvDriverInfo?.register(UINib(nibName: "DeliveryActionButtonCell", bundle: nil), forCellWithReuseIdentifier: "DeliveryActionButtonCell")
        
    }

}


//MARK: Extension
//MARK:API CALL
extension DeliveryDetailsViewController{
    //get delivery details
    private func getDeliveryDetails() -> Void {
        let url = "\(ApiEndpoints.URI_GET_DELIVERY_DETAILS)/5"
        DeliveryService.getInstance().getDeliveryDetailsRequest(url: url, completionHandler: {
            response in
            
            print("\(self.CLASS_NAME) -- DeliveryDetailsViewController() -- url = \(url),  response = \(response)")
            
            if response.result.isSuccess{
                let json = JSON(response.data!)
                
                if json.arrayValue.count > 0{
                    self.userShippingAddress.id = json[0]["id"].int
                    self.userShippingAddress.userId = json[0]["userId"].int
                    self.userShippingAddress.addressLine1 = json[0]["addressLine1"].string
                    self.userShippingAddress.addressLine2 = json[0]["addressLine2"].string
                    self.userShippingAddress.city = json[0]["city"].string
                    self.userShippingAddress.state = json[0]["state"].string
                    self.userShippingAddress.zipCode = json[0]["zipCode"].string
                    self.userShippingAddress.lattitude = json[0]["lat"].string
                    self.userShippingAddress.longitude = json[0]["lon"].string
                    
                    //show user shipping address
                    if (self.userShippingAddress.addressLine2 ?? "").elementsEqual(""){
                        
                    }else{
                        //show user location
//                        self.showUserLocation()
                    }
                }
            }
        })
    }
}

//MARK: CollectionView
extension DeliveryDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for header cell
        if indexPath.row == 0{
            return CGSize(width: cvDriverInfo.frame.width, height: 375)
        }
            
            //if main tab bar cell
        else if indexPath.row == 1{
            return CGSize(width: cvDriverInfo.frame.width, height: 170)
        }
            
            //if category title cell
        else if indexPath.row == 2{
            return CGSize(width: cvDriverInfo.frame.width, height: 130)
        }
            
            //if food item cell
        else{
            return CGSize(width: cvDriverInfo.frame.width, height: 190)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for header cell
        if indexPath.row == 0{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveryDetailsMapCell", for: indexPath) as! DeliveryDetailsMapCell
            
            return cell
        }
            
            //for main tab bar  cell
        else if indexPath.row == 1{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveryPickupDropoffCell", for: indexPath) as! DeliveryPickupDropoffCell
            
            Helper.maskView(cell.uivContent, topLeftRadius: 25, bottomLeftRadius: 0, bottomRightRadius: 0, topRightRadius: 25, width: cvDriverInfo.frame.width, height: cell.uivContent.frame.height)
            
            return cell
        }
            
            //for category cell
        else if indexPath.row == 2{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveryDistanceAndTimeCell", for: indexPath) as! DeliveryDistanceAndTimeCell
            
            cell.uivCircularProgressbar.value = 0
            UIView.animate(withDuration: 2, animations: {
                cell.uivCircularProgressbar.value = 40
                cell.uivCircularProgressbar.layoutIfNeeded()
            })
            
            return cell
        }
            
            //for food item cell
        else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveryActionButtonCell", for: indexPath) as! DeliveryActionButtonCell
            
            return cell
        }
        
    }

}

