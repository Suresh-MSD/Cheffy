//
//  HomeViewController.swift
//  chef
//
//  Created by Eddie Ha on 20/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import CoreLocation

enum FoodListing : Int {
    case Search = 0
    case New = 1
    case Popular_Near = 2
    case Popular_Food = 3
}

class HomeViewController: BaseViewController {
    //MARK: Properties
    public let CLASS_NAME = HomeViewController.self.description()
    public var newPlateList = [Plate]()
    public var nearPlateList = [Plate]()
    public var popularPlateList = [Plate]()
    public var AllPlateList = [Plate]()
    public var favList = [FavouriteModel]()
    public var SearchPlateList = [Plate]()
    
    private let refreshControl = UIRefreshControl()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
    private let plateService = PlateService.getInstance()
    
    public var addressText: String?
    
    public var is_SearchPlat = false
    //    var Search_Delegate : SearchBarCellDelegate?
    //MARK: Outlets
    @IBOutlet weak var cvFoodWithCategoryList: UICollectionView!
    
    //Sort Filter
    @IBOutlet weak var PickedButton: UIButton!
    @IBOutlet weak var PopularButton: UIButton!
    @IBOutlet weak var RatingButton: UIButton!
    @IBOutlet weak var DeliveryButton: UIButton!
    
    //Sort Filter
    @IBOutlet var Selection_Image: [UIImageView]!
    var Sorting_Selection_Index = Int()
    @IBOutlet weak var SortView: UIView!
    @IBOutlet weak var Sort_BottomConstrain: NSLayoutConstraint!
    
    //Price Range Filter
    var Selected_PriceRange = [String]()
    @IBOutlet weak var PriceView: UIView!
    @IBOutlet var Selection_Price: [UIButton]!
    @IBOutlet weak var BottomConstrain: NSLayoutConstraint!
    
    //Delivery Filter
    var Selected_DeliveryFee = Int()
    @IBOutlet weak var DeliveryView: UIView!
    @IBOutlet var Selection_Delivery: [UIButton]!
    @IBOutlet weak var Delivery_BottomConstrain: NSLayoutConstraint!
    
    //Dietary Filter
    var Diet_Filter_Name = ["vegetarian","vegan","gluten-free","halal"]
    var Selected_Diet = [String]()
    @IBOutlet weak var Dietary: UIView!
    @IBOutlet var Selection_Dietary: [UIButton]!
    @IBOutlet var Selection_Dietary_Image: [UIImageView]!
    @IBOutlet weak var Dietary_BottomConstrain: NSLayoutConstraint!
    
    
    public var is_FilterPlate = false
    public var UserShipping_Address : UserShippingAddress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
        reload()
        configureLocationService()
        self.Set_Filter_View()
        //        Search_Delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func reload() {
        if isConnectedToNetwork() {
            getUserShippingAddress()
            getNewPlateList()
            getFavouritePlateList()
            
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }
        
    }
    
    //MARK: Actions
    @objc func reloadData(){
        if isConnectedToNetwork() {
            getNewPlateList()
            refreshControl.beginRefreshing()
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }
    }
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvFoodWithCategoryList.delegate = self
        cvFoodWithCategoryList.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: cvFoodWithCategoryList.frame.width, height: 300)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        cvFoodWithCategoryList.collectionViewLayout = layout
        
        //cell for food list collection view
        
        cvFoodWithCategoryList?.register(UINib(nibName: "SearchBarCell", bundle: nil), forCellWithReuseIdentifier: "SearchBarCell")
        cvFoodWithCategoryList?.register(UINib(nibName: "FoodListWithCategoryCell", bundle: nil), forCellWithReuseIdentifier: "FoodListWithCategoryCell")
        
        cvFoodWithCategoryList?.register(UINib(nibName: "PopularFoodListCell", bundle: nil), forCellWithReuseIdentifier: "PopularFoodListCell")
        cvFoodWithCategoryList?.register(UINib(nibName: "CategoryTitleCell", bundle: nil), forCellWithReuseIdentifier: "CategoryTitleCell")
        cvFoodWithCategoryList?.register(UINib(nibName: "FoodItemCell", bundle: nil), forCellWithReuseIdentifier: "FoodItemCell")
        
        cvFoodWithCategoryList?.register(UINib(nibName: "FoodItemCell", bundle: nil), forCellWithReuseIdentifier: "FoodItemCell")
        
        //setup UIRefreshControll
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.reloadData), for: .valueChanged)
        self.cvFoodWithCategoryList.alwaysBounceVertical = true
        self.cvFoodWithCategoryList.addSubview(refreshControl)
        self.refreshControl.backgroundColor = .clear
    }
    
    // Set_Filter_Selection_View
    func Set_Filter_View() {
        
        self.Dietary.frame = self.view.bounds
        for i in 0..<4 {
           Selection_Dietary_Image[i].image = nil
        }
        self.view.addSubview(self.Dietary)
        
        self.DeliveryView.frame = self.view.bounds
        self.view.addSubview(self.DeliveryView)
        for i in 0..<4 {
            Selection_Delivery[i].layer.cornerRadius = Selection_Delivery[i].frame.size.width / 2
            Selection_Delivery[i].backgroundColor = UIColor.white
            Selection_Delivery[i].setTitleColor(UIColor.black, for: .normal)
        }
        
        self.PriceView.frame = self.view.bounds
        self.view.addSubview(self.PriceView)
        for i in 0..<4 {
            Selection_Price[i].layer.cornerRadius = Selection_Price[i].frame.size.width / 2
            Selection_Price[i].backgroundColor = UIColor.white
            Selection_Price[i].setTitleColor(UIColor.black, for: .normal)
        }
        
        self.SortView.frame = self.view.bounds
        self.view.addSubview(self.SortView)
        for i in 0..<4 {
            Selection_Image[i].isHidden = true
            
        }
    }
    
    @IBAction func Sort_Filter_Apply(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.SortView.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
            
            self.Sort_BottomConstrain.constant = -350.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        self.FilterAPI(param: "?sort=\(self.Sorting_Selection_Index)")
    }
    
    @IBAction func Price_Filter_Apply(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.PriceView.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
            
            self.BottomConstrain.constant = -220.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        let ary = self.Selected_PriceRange.joined(separator: "&")
        
        self.FilterAPI(param: "?\(ary)")
    }
    
    @IBAction func Delivery_Filter_Apply(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.DeliveryView.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
            
            self.Delivery_BottomConstrain.constant = -220.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        self.FilterAPI(param: "?deliveryPrice=\(self.Selected_DeliveryFee)")
    }
    
    @IBAction func Dietary_Filter_Apply(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.Dietary.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
            
            self.Dietary_BottomConstrain.constant = -350.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        let ary = self.Selected_Diet.joined(separator: "&")
        
        self.FilterAPI(param: "?\(ary)")
    }
    
    @IBAction func Cancel_Filter(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.PriceView.alpha = 0.0
            self.SortView.alpha = 0.0
            self.DeliveryView.alpha = 0.0
            self.Dietary.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
            
            self.BottomConstrain.constant = -220.0
            self.Delivery_BottomConstrain.constant = -220.0
            self.Sort_BottomConstrain.constant = -350.0
            self.Dietary_BottomConstrain.constant = -350.0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        self.Set_Filter_View()
        
    }
    
    //Delivery Button
    @IBAction func Delivery_Button_Click(_ sender: UIButton) {
        
        for i in 0..<4 {
            
            if Selection_Delivery[i].tag == sender.tag {
                Selection_Delivery[i].backgroundColor = UIColor.black
                Selection_Delivery[i].setTitleColor(UIColor.white, for: .normal)
                Selected_DeliveryFee = sender.tag
            } else {
                Selection_Delivery[i].backgroundColor = UIColor.white
                Selection_Delivery[i].setTitleColor(UIColor.black, for: .normal)
            }
        }
        
    }
    
    //Dietary Button
    @IBAction func Dietary_Button_Click(_ sender: UIButton) {
        
        for i in 0..<4 {
            if sender.tag == Selection_Dietary_Image[i].tag {
                let Back_image = Selection_Dietary_Image[i].image
                if (Back_image?.isEqualToImage(image: UIImage(named: "ic_Selected") ?? UIImage())) ?? false  {
                    
                    let index = self.Selected_Diet.firstIndex(of: "dietary=" + self.Diet_Filter_Name[sender.tag])
                    self.Selected_Diet.remove(at: index!)
                    Selection_Dietary_Image[i].image = nil
                    
                } else {
                    
                    self.Selected_Diet.append("dietary=" + Diet_Filter_Name[sender.tag])
                    Selection_Dietary_Image[i].image = UIImage(named: "ic_Selected")
                }
                
            }
        }
        print(self.Selected_Diet)
    }
    
    //Sort Button
    @IBAction func Sort_Button_Click(_ sender: UIButton) {
        
        for i in 0..<4 {
            
            if Selection_Image[i].tag == sender.tag {
                Selection_Image[i].isHidden = false
                if sender.tag == 0 {
                    self.Sorting_Selection_Index = 5
                } else {
                    self.Sorting_Selection_Index = sender.tag
                }
                
            } else {
                Selection_Image[i].isHidden = true
            }
        }
        
    }
    
    //Price Button
    @IBAction func Price_Button_Click(_ sender: UIButton) {
        
        for i in 0..<4 {
            
            if sender.tag == Selection_Price[i].tag {
                let Back_Color = Selection_Price[i].backgroundColor!
                if Back_Color == UIColor.white {
                    Selection_Price[i].backgroundColor = UIColor.black
                    Selection_Price[i].setTitleColor(UIColor.white, for: .normal)
                    self.Selected_PriceRange.append("priceRange=\(sender.tag)")
                } else {
                    Selection_Price[i].backgroundColor = UIColor.white
                    Selection_Price[i].setTitleColor(UIColor.black, for: .normal)
                    let index = Selected_PriceRange.index(of: "priceRange=\(sender.tag)") ?? 0
                    self.Selected_PriceRange.remove(at: index)
                }
            }
        }
        print(self.Selected_PriceRange)
    }
    
    //go to chef details view controller
    private func loadChefDetailsViewController(plateId: Int) -> Void {
        
        ChefDetailsViewController.present(navigationController: self.navigationController, plateId: plateId)
    }
    
    func FilterAPI(param : String) {
        
        if !refreshControl.isRefreshing{
            ProgressViewHelper.show(type: .full)
        }
        let url = ApiEndpoints.URI_GET_PLATE_LIST + param
        
        print(url)
        
        FoodCategoryService.getInstance().getRequest(url: url, completionHandler: { [weak self]
            response in
            
            ProgressViewHelper.hide()
            if let strongSelf = self {
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    //remove all previous data
                    print(json)
                    strongSelf.SearchPlateList.removeAll()
                    for item in json["data"].arrayValue{
                        let plate = strongSelf.getPlateObject(item: item)
                        strongSelf.SearchPlateList.append(plate)
                    }
                    //reload collection view
                    strongSelf.is_SearchPlat = true
                    strongSelf.cvFoodWithCategoryList.reloadData()
                } else {
                    strongSelf.refreshControl.endRefreshing()
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
}


//MARK: Extension
//MARK: API Call
extension HomeViewController{
    
    private func getPlateObject(item : JSON)->Plate{
        let plate = Plate()
        if let plate_id = item["plate_id"].int{
            plate.id = plate_id
        }else  if let id = item["id"].int{
            plate.id = id
        }
        plate.name = item["name"].string
        plate.plateDescription = item["description"].string
        plate.featuredImage = item["imageURL"].string
        plate.distance = item["distance"].string
        plate.deliveryType = item["delivery_type"].string
        plate.price = item["price"].double
        plate.deliveryTime = item["delivery_time"].int
        plate.rating = item["rating"].double
        plate.available = item["available"].bool
        //make plateImages
        var plateImageList = [PlateImage]()
        
        for plateImageJson in item["PlateImages"].arrayValue{
            var plateImage = PlateImage()
            plateImage.name = plateImageJson["name"].string
            plateImage.url = plateImageJson["url"].string
            plateImageList.append(plateImage)
        }
        
        let reviewdetails = item["AggregateReview"].dictionaryValue
        let AggregateList = AggregateReview()
        AggregateList.id = reviewdetails["id"]?.int
        AggregateList.review_type = reviewdetails["review_type"]?.stringValue
        AggregateList.chefID = reviewdetails["chefID"]?.int
        AggregateList.driverID = reviewdetails["driverID"]?.int
        AggregateList.plateId = reviewdetails["plateId"]?.int
        AggregateList.userCount = reviewdetails["userCount"]?.int
        AggregateList.rating = reviewdetails["rating"]?.double
        
        plate.AggregateReview = AggregateList
        plate.plateImageList = plateImageList
        return plate
    }
    
    //get all new plate by pagination list
    private func getNewPlateList()  {
        
        if !refreshControl.isRefreshing{
            ProgressViewHelper.show(type: .full)
        }
        let url = ApiEndpoints.URI_GET_PLATE_LIST
        FoodCategoryService.getInstance().getRequest(url: url, completionHandler: { [weak self]
            response in
            
            ProgressViewHelper.hide()
            if let strongSelf = self {
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    //remove all previous data
                    print(json)
                    strongSelf.newPlateList.removeAll()
                    for item in json["data"].arrayValue{
                        let plate = strongSelf.getPlateObject(item: item)
                        strongSelf.newPlateList.append(plate)
                    }
                    
                    
                    //reload collection view
                    strongSelf.cvFoodWithCategoryList.reloadData()
                    strongSelf.getNearPlateList()
                } else {
                    strongSelf.refreshControl.endRefreshing()
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
        
    }
    
    //get all near plate by pagination list
    private func getNearPlateList() -> Void {
        
        guard let currLocation = currentLocation else {
            ProgressViewHelper.hide()
            refreshControl.endRefreshing()
            return}
        
        //        let url1 = ApiEndpoints.URI_GET_NEAR_PLATE_LIST + "&latitude=\(currLocation.latitude)&longitude=\(currLocation.longitude)&radius=\(10)"
        
        let url1 = ApiEndpoints.URI_GET_NEAR_PLATE_LIST + "&lat=\(currLocation.latitude)&lon=\(currLocation.longitude)&radius=\(10000)"
        
        FoodCategoryService.getInstance().getRequest(url: url1, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    //remove all previous data
                    strongSelf.nearPlateList.removeAll()
                    for item in json["data"].arrayValue{
                        strongSelf.nearPlateList.append(strongSelf.getPlateObject(item: item))
                    }
                    //reload collection view
                    strongSelf.cvFoodWithCategoryList.reloadData()
                    strongSelf.refreshControl.endRefreshing()
                    strongSelf.PopularPlateList()
                } else {
                    
                    strongSelf.refreshControl.endRefreshing()
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
    
    
    //get all popular plate by pagination list
    private func getPopularPlateList() {
        guard let currLocation = currentLocation else {
            ProgressViewHelper.hide()
            refreshControl.endRefreshing()
            return}
        
        NearPlateRequest(latitude: currLocation.latitude, longitude: currLocation.longitude, radius: 10).exec { [weak self]
            result, error in
            switch((result, error)) {
            case (let .some(r), nil):
                self?.popularPlateList = r.map { p in
                    let plate = Plate()
                    plate.id = p.plate_id
                    plate.name = p.name
                    plate.featuredImage = p.imageURL
                    plate.distance = "\(p.distance)"
                    plate.deliveryType = p.delivery_type
                    plate.price = p.price
                    plate.deliveryTime = Int(p.delivery_time)
                    plate.rating = Double(p.rating)
                    return plate
                }
                self?.cvFoodWithCategoryList.reloadData()
                break
            case (nil, .some(_)):
                break
            default: break
            }
        }
    }
    
    
    private func getPopulerPlateObject(item : JSON)->Plate{
        
        let Popularplate = Plate()
        if let plate_id = item["plate_id"].int{
            Popularplate.id = plate_id
        }else  if let id = item["id"].int{
            Popularplate.id = id
        }
        Popularplate.name = item["name"].string
        Popularplate.plateDescription = item["description"].string
        Popularplate.price = item["price"].double
        Popularplate.deliveryTime = item["delivery_time"].int
        Popularplate.available = item["chefDeliveryAvailable"].bool
        
        return Popularplate
    }
    
    //get all popular plate by pagination list
    private func PopularPlateList() {
        
        if !refreshControl.isRefreshing{
            ProgressViewHelper.show(type: .full)
        }
        let url = ApiEndpoints.URI_GET_POPULER_PLATE
        
        FoodCategoryService.getInstance().getRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    //remove all previous data
                    strongSelf.popularPlateList.removeAll()
                    for item in json["data"].arrayValue{
                        strongSelf.popularPlateList.append(strongSelf.getPopulerPlateObject(item: item))
                    }
                    //reload collection view
                    strongSelf.cvFoodWithCategoryList.reloadData()
                    strongSelf.refreshControl.endRefreshing()
                } else {
                    
                    strongSelf.refreshControl.endRefreshing()
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
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
    
    //get all favourite plate list
    private func getFavouritePlateList()  {
        if !refreshControl.isRefreshing{
            ProgressViewHelper.show(type: .full)
        }
        let url = ApiEndpoints.URI_GET_FAVOURITE_LIST
        
        FoodCategoryService.getInstance().getRequest(url: url, completionHandler: { [weak self]
            response in
            
            ProgressViewHelper.hide()
            if let strongSelf = self {
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    //remove all previous data
                    print(json)
                    strongSelf.favList.removeAll()
                    strongSelf.favList.append(FavouriteModel(fromDictionary: json.dictionaryObject!))
                    print(strongSelf.favList)
                    //reload collection view
                    strongSelf.cvFoodWithCategoryList.reloadData()
                } else {
                    strongSelf.refreshControl.endRefreshing()
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
    
    func Reset_Filter() {
        
        self.Sorting_Selection_Index = Int()
        self.is_SearchPlat = false
        self.SearchPlateList.removeAll()
        self.Set_Filter_View()
    }
    
    @objc func Click_Filter(sender:UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            sender.transform = sender.transform.rotated(by: CGFloat(M_PI_2 * 2))
            self.view.layoutIfNeeded()
        }
        
        if self.is_FilterPlate {
            self.is_FilterPlate = false
            self.Reset_Filter()
            self.cvFoodWithCategoryList.reloadData()
        } else {
            self.is_FilterPlate = true
            self.cvFoodWithCategoryList.reloadData()
        }
    }
    
    @objc func Click_Sub_Filter(sender:UIButton) {
        
        let tag = sender.tag - 2000
        if tag == 0 {
            UIView.animate(withDuration: 0.3) {
                self.SortView.alpha = 1.0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                
                self.Sort_BottomConstrain.constant = -15.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        } else if tag == 1 {
            
            UIView.animate(withDuration: 0.3) {
                self.PriceView.alpha = 1.0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                
                self.BottomConstrain.constant = -15.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
        } else if tag == 2 {
            
            UIView.animate(withDuration: 0.3) {
                self.DeliveryView.alpha = 1.0
            }
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                
                self.Delivery_BottomConstrain.constant = -15.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
        } else if tag == 3 {
            UIView.animate(withDuration: 0.3) {
                self.Dietary.alpha = 1.0
            }
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                
                self.Dietary_BottomConstrain.constant = -15.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
        
    }
    
    
    //Add favourite
    private func addFavourite() -> Void {
        
        let url = ApiEndpoints.URI_POST_ADD_FAVOURITE
        let parameters: [String: Any] = [
            "fav_type": "plate",
            "Customplateid":"1000"
        ]
        plateService.postAddFavouriteRequest(url: url, parameters: parameters) { (response) in
            print(response)
        }
    }
    
    //get all new plate by pagination list
    private func getSearchFoodRestroList(string : String)  {
        
        if !refreshControl.isRefreshing{
            ProgressViewHelper.show(type: .full)
        }
        let url = ApiEndpoints.URI_GET_SEARCH_FOOD_RESTRO + string
        
        SearchFoodRestroService.getInstance().getRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    //remove all previous data
                    print(json)
                    strongSelf.SearchPlateList.removeAll()
                    for item in json["plates"].arrayValue{
                        let plate = strongSelf.getPlateObject(item: item)
                        strongSelf.SearchPlateList.append(plate)
                    }
                    //reload collection view
                    strongSelf.cvFoodWithCategoryList.reloadData()
                    //                    strongSelf.getNearPlateList()
                } else {
                    
                    strongSelf.refreshControl.endRefreshing()
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
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
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if is_SearchPlat {
            
            if SearchPlateList.isEmpty {
                
                collectionView.setEmptyMessage("Plate appears here")
            } else {
                collectionView.restore()
            }
        }
        
        return is_SearchPlat ? (SearchPlateList.count + 1) : (popularPlateList.count + 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.is_FilterPlate {
            var height : CGFloat = 0.0
            
            if indexPath.row == FoodListing.Popular_Near.rawValue {
                
                height = 330
                
            } else {
                height = indexPath.row == FoodListing.Search.rawValue ? 170 : 280
            }
            
            return CGSize(width: cvFoodWithCategoryList.frame.width, height: height)
        } else {
            
            var height : CGFloat = 0.0
            
            if indexPath.row == FoodListing.Popular_Near.rawValue {
                
                height = 330
                
            } else {
                height = indexPath.row == FoodListing.Search.rawValue ? 110 : 280
            }
            
            return CGSize(width: cvFoodWithCategoryList.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for first  cell
        
        if is_SearchPlat {
            
            if indexPath.row == FoodListing.Search.rawValue {
                
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "SearchBarCell", for: indexPath) as! SearchBarCell
                cell.delegate = self
                
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
                
            } else {
                
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemCell", for: indexPath) as! FoodItemCell
                
                cell.configureCategoryList(plate: SearchPlateList[indexPath.row - 1])
                return cell
            }
            
        }
        
        if indexPath.row == FoodListing.Search.rawValue {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "SearchBarCell", for: indexPath) as! SearchBarCell
            cell.delegate = self
            
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
            cell.SerchButton.addTarget(self, action: #selector(self.Click_Filter(sender:)), for: .touchUpInside)
            cell.SerchButton.tag = 1000 + indexPath.row
            let FilterScroll = UIScrollView()
            
            if self.is_FilterPlate {
                
                cell.FilterView.isHidden = false
                
                FilterScroll.frame = cell.FilterView.bounds
                FilterScroll.showsHorizontalScrollIndicator = false
                cell.FilterView.addSubview(FilterScroll)
                
                let Button_Names = ["Sort","Price Range","Max Delivery Free","Dietary"]
                let Button_Width : [CGFloat] = [100.0,150.0,200.0,120.0]
                var Filter_Button_X : CGFloat = 0.0
                for i in 0..<4 {
                    let FilterButton = LeftAlignedIconButton()
                    FilterButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
                    FilterButton.frame = CGRect(x: Filter_Button_X, y: 5, width: Button_Width[i], height: FilterScroll.frame.size.height - 10)
                    FilterButton.setImage(UIImage(named: "ic_Down_Arrow"), for: .normal)
                    FilterButton.setTitle(Button_Names[i], for: .normal)
                    FilterButton.backgroundColor = UIColor(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1.0)
                    FilterButton.addTarget(self, action: #selector(self.Click_Sub_Filter(sender:)), for: .touchUpInside)
                    FilterButton.tag = 2000 + i
                    FilterButton.setTitleColor(UIColor.black, for: .normal)
                    FilterButton.layer.cornerRadius = FilterButton.frame.size.height / 2
                    FilterScroll.addSubview(FilterButton)
                    Filter_Button_X = Filter_Button_X + Button_Width[i] + 10
                    FilterScroll.contentSize = CGSize(width: Filter_Button_X, height: cell.FilterView.bounds.size.height)
                }
                
                
            } else {
                
                cell.FilterView.isHidden = true
                for view in cell.FilterView.subviews{
                    view.removeFromSuperview()
                }
                FilterScroll.removeFromSuperview()
            }
            
            return cell
        }
            
        else if indexPath.row == FoodListing.New.rawValue{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FoodListWithCategoryCell", for: indexPath) as! FoodListWithCategoryCell
            
            cell.lblCategory.text = "New on Cheffy"
            cell.plateList = newPlateList
            cell.onPress = {plate in ChefDetailsViewController.present(navigationController: self.navigationController, plateId: plate.id!)}
            return cell
        }
            
        else if indexPath.row == FoodListing.Popular_Near.rawValue{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "PopularFoodListCell", for: indexPath) as! PopularFoodListCell
            cell.lblCategory.text = "Popular Near You"
            cell.plateList = nearPlateList
            cell.onPress = {plate in ChefDetailsViewController.present(navigationController: self.navigationController, plateId: plate.id!)}
            
            return cell
        }
            
            //        else {
            //
            //            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FoodListWithCategoryCell", for: indexPath) as! FoodListWithCategoryCell
            //            cell.lblCategory.text = "Popular Food"
            //            cell.plateList = popularPlateList
            //            cell.onPress = {plate in ChefDetailsViewController.present(navigationController: self.navigationController, plateId: plate.id!)}
            //
            //            return cell
            //        }
        else {
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemCell", for: indexPath) as! FoodItemCell
            
            let plate = popularPlateList[indexPath.row-3]
            
            cell.highlightView.isHidden = plate.available ?? true
            cell.lblFoodName.text = plate.name?.capitalizingFirstLetter()
            cell.lblRating.text = "\(plate.rating ?? 0)"
            cell.lblTimeline.text = "\(plate.deliveryTime ?? 0) - \((plate.deliveryTime ?? 0) + 5) min"
            
            if (plate.available ?? true) == true {
                cell.lblDelivery.text = "Free"
            }else {
                cell.lblDelivery.text = "Paid"
            }
            
            if let url = URL(string: plate.featuredImage ?? "") {
                let resource: ImageResource = ImageResource(downloadURL: url, cacheKey: plate.featuredImage ?? "")
                cell.ivFeatureImage.kf.setImage(with: resource)
            }
            //            cell.ivFeatureImage.kf.setImage(with: ImageResource(downloadURL: URL(string: plate.featuredImage ?? "")!, cacheKey: plate.featuredImage ?? ""))
            
            cell.ivFeatureImage.layer.cornerRadius = 10
            cell.ivFeatureImage.clipsToBounds = true
            cell.ivFeatureImage.layer.borderColor = UIColor.lightGray.cgColor
            cell.ivFeatureImage.layer.shadowColor = UIColor.black.cgColor
            cell.ivFeatureImage.layer.shadowOpacity = 0.5
            cell.ivFeatureImage.layer.shadowRadius = 10.0
            cell.ivFeatureImage.layer.shadowOffset = CGSize(width: 1, height: 1)
            
            cell.uivFeaturedImageContainer.elevate(elevation: 6, cornerRadius: 15)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if is_SearchPlat {
            
            if indexPath.row != 0 {
                loadChefDetailsViewController(plateId: SearchPlateList[indexPath.row-1].id ?? 0)
            }
        } else {
            print(indexPath.row)
            if indexPath.row >= FoodListing.Popular_Food.rawValue {
                loadChefDetailsViewController(plateId: popularPlateList[indexPath.row-3].id ?? 0)
            }
        }
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    // location manger
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = locValue
    }
    
    func configureLocationService() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("User did not selecte for this app ")
        case .denied:
            print("location service is invalid")
        case .restricted:
            print("this app cannot use location service")
        case .authorizedAlways:
            print("app always use location service")
            locationManager.startUpdatingLocation()
        case.authorizedWhenInUse:
            print("app can use location service when this app is awaken")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("error")
        }
    }
}

extension HomeViewController: SearchBarCellDelegate {
    
    func search(text: String) {
        
        if text != "" {
            
            is_SearchPlat = true
            self.getSearchFoodRestroList(string: text)
        } else {
            
            is_SearchPlat = false
            self.cvFoodWithCategoryList.reloadData()
        }
    }
    
    func stop_search() {
        
        is_SearchPlat = false
        self.cvFoodWithCategoryList.reloadData()
    }
}
