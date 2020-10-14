//
//  FoodListViewController.swift
//  chef
//
//  Created by Eddie Ha on 22/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Kingfisher

class FoodListViewController: BaseViewController {
    
    //MARK: Properties
    public let CLASS_NAME = FoodListViewController.self.description()
    public var foodItemList = [Food]()
    public var plateList = [Plate]()
    open var categoryId:Int?
    private let refreshControl = UIRefreshControl()
    
    //MARK: Outlets
    @IBOutlet weak var cvFoodItemList: UICollectionView!
    
    public var UserShipping_Address : UserShippingAddress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization code
        initialization()
        //Get shipping address
        getUserShippingAddress()
        //get food data
        getPlateListByCategory(categoryId: categoryId ?? -1)
        cvFoodItemList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Actions
    //reload data
    @objc func reloadData(){
        //get category list
        getPlateListByCategory(categoryId: categoryId ?? -1)
    }
    
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvFoodItemList.delegate = self
        cvFoodItemList.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (cvFoodItemList.frame.width)-20, height: 280)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        cvFoodItemList.collectionViewLayout = layout
        
        //cell for food list collection view
        let nibForSearchBarCell = UINib(nibName: "SearchBarCell", bundle: nil)
        cvFoodItemList?.register(nibForSearchBarCell, forCellWithReuseIdentifier: "SearchBarCell")
        let nibForFoodItemCell = UINib(nibName: "FoodItemCell", bundle: nil)
        cvFoodItemList?.register(nibForFoodItemCell, forCellWithReuseIdentifier: "FoodItemCell")
        
        //setup UIRefreshControll
        self.refreshControl.addTarget(self, action: #selector(FoodListViewController.reloadData), for: .valueChanged)
        self.cvFoodItemList.alwaysBounceVertical = true
        self.cvFoodItemList.addSubview(refreshControl)
        self.refreshControl.backgroundColor = .clear
        
    }
}


//MARK: Extension
//MARK: API Call
extension FoodListViewController{
    //get all new plate by pagination list
    private func getPlateListByCategory(categoryId: Int) -> Void {
        
        // TODO: API check URL and response type
        if isConnectedToNetwork() {
            if !refreshControl.isRefreshing{
                ProgressViewHelper.show(type: .full)
            }
            
            let url = ApiEndpoints.URI_GET_PLATE_LIST_BY_CATEGORY + "/\(categoryId)"
            print(url)
            FoodCategoryService.getInstance().getRequest(url: url, completionHandler: { [weak self]
                response in
                ProgressViewHelper.hide()
                if let strongSelf = self {
                    strongSelf.refreshControl.endRefreshing()
                    if response.result.isSuccess{
                        let json = JSON(response.data!)
                        //remove all previous data
                        strongSelf.plateList.removeAll()
                        let data = json["data"].arrayValue
                        for item in data{
                            let plate = Plate()
                            plate.id = item["id"].int
                            plate.name = item["name"].string
                            plate.plateDescription = item["description"].string
                            plate.featuredImage = item["imageURL"].string
                            plate.distance = item["distance"].string
                            plate.deliveryType = item["delivery_type"].string
                            plate.price = item["price"].double
                            plate.deliveryTime = item["delivery_time"].int
                            plate.rating = item["rating"].double
                            plate.chefDeliveryAvailable = item["chefDeliveryAvailable"].bool
                            
                            //make plateImages
                            var plateImageList = [PlateImage]()
                            
                            for plateImageJson in item["PlateImages"].arrayValue{
                                var plateImage = PlateImage()
                                plateImage.name = plateImageJson["name"].string
                                plateImage.url = plateImageJson["url"].string
                                plateImageList.append(plateImage)
                            }
                            
                            plate.plateImageList = Optional(plateImageList)
                            strongSelf.plateList.append(plate)
                            
                        }
                        //reload collection view
                        strongSelf.cvFoodItemList.reloadData()
                    } else {
                        strongSelf.refreshControl.endRefreshing()
                        strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                    }
                }
            })
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }
    }
    
    //get user shipping address
    private func getUserShippingAddress() {
        
        if !refreshControl.isRefreshing{
            ProgressViewHelper.show(type: .full)
        }
        
        let url = ApiEndpoints.URI_GET_USER_SHIPPING_ADRESS
        
        UserProfileService.getInstance().getUserShippingAddress(url: url, completionHandler: {
            response in
            
            ProgressViewHelper.hide()
            
            if response.result.isSuccess{
                let json = JSON(response.data!)
                print(json)
                let add_data = json["data"].arrayValue
                if !add_data.isEmpty {
                    
                    for Address in add_data {
                        
                        if let isDefaultAddress = Address["isDefaultAddress"].bool {
                            
                            if isDefaultAddress {
                                
                                let Shipping_Address = UserShippingAddress()
                                
                                Shipping_Address.id = Address["id"].int
                                Shipping_Address.userId = Address["userId"].int
                                Shipping_Address.addressLine1 = Address["addressLine1"].string
                                Shipping_Address.addressLine2 = Address["addressLine2"].string
                                Shipping_Address.city = Address["city"].string
                                Shipping_Address.state = json["state"].string
                                Shipping_Address.zipCode = Address["zipCode"].string
                                Shipping_Address.lattitude = Address["lat"].string
                                Shipping_Address.longitude = Address["lon"].string
                                Shipping_Address.isDefaultAddress = Address["isDefaultAddress"].bool
                                Shipping_Address.deliveryNote = Address["deliveryNote"].stringValue
                                
                                self.UserShipping_Address = Shipping_Address
                            }
                        }
                    }
                } else {
                    self.showMessageWith("", "No Shipping Address Found", .info)
                }
            }
        })
    }
    
    @objc func ClickAddress( sender : UIButton) {
        
        if !Helper.isLoggedIn() {
            SnackbarCollection.showSnackbarWithText(text: "Login for add shipping address.")
            return
        }
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShippingAddress") as! ShippingAddress
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: CollectionView
extension FoodListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if plateList.isEmpty{
            collectionView.setEmptyMessage("No plates available")
        }else{
            collectionView.restore()
        }
        return plateList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize(width: cvFoodItemList.frame.width-20, height: 150)
        }
            //for FoodCategoryCell
        else{
            return CGSize(width: (cvFoodItemList.frame.width)-20, height: 280)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for first  cell
        if indexPath.row == 0{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "SearchBarCell", for: indexPath) as! SearchBarCell
            
            if let add = self.UserShipping_Address {
                
                if add.addressLine1 != "" || add.addressLine2 != "" {
                    cell.locationLabel.text = "\(add.addressLine1 ?? ""), \(add.addressLine2 ?? "")"
                } else {
                    cell.locationLabel.text = "\(add.city ?? ""), \(add.state ?? "")"
                }
            } else {
                
                cell.locationLabel.text = "Add delivery address"
            }
            
            cell.addressButton.addTarget(self, action: #selector(self.ClickAddress(sender:)), for: .touchUpInside)
            
            return cell
        }
            
            //for food item  cell
        else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemCell", for: indexPath) as! FoodItemCell
            
            let plate = plateList[indexPath.row-1]
            print(plate.id)
            cell.configureCategoryList(plate: plate)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != 0{
        
            let plate = plateList[indexPath.row-1]
            ChefDetailsViewController.present(navigationController: self.navigationController, plateId: plate.id ?? 0)
            
        }
        
    }
}
