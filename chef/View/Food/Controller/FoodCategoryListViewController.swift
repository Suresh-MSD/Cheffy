//
//  FoodListViewController.swift
//  chef
//
//  Created by Eddie Ha on 22/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftyJSON
import MaterialComponents
import Kingfisher

class FoodCategoryListViewController: BaseViewController {
    //MARK: Properties
    public let CLASS_NAME = FoodCategoryListViewController.self.description()
    private var foodCategoryList = [FoodCategory]()
    private let refreshControl = UIRefreshControl()
    public var is_SearchPlat = false
    
    //MARK: Outlets
    @IBOutlet weak var cvFoodCategoryList: UICollectionView!

    public var is_FilterPlate = false
    
    //Sort Filter
    @IBOutlet var Selection_Image: [UIImageView]!
    var Sorting_Selection_Index = Int()
    @IBOutlet weak var SortView: UIView!
    @IBOutlet weak var Sort_BottomConstrain: NSLayoutConstraint!
    
    //Price Range Filter
    @IBOutlet weak var PriceView: UIView!
    @IBOutlet var Selection_Price: [UIButton]!
    @IBOutlet weak var BottomConstrain: NSLayoutConstraint!
    
    //Delivery Filter
    @IBOutlet weak var DeliveryView: UIView!
    @IBOutlet var Selection_Delivery: [UIButton]!
    @IBOutlet weak var Delivery_BottomConstrain: NSLayoutConstraint!
    
    //Dietary Filter
    var Diet_Filter_Name = ["Vegetarian","Vegan","Gluten-free","Halal"]
    var Selected_Diet = [String]()
    @IBOutlet weak var Dietary: UIView!
    @IBOutlet var Selection_Dietary: [UIButton]!
    @IBOutlet var Selection_Dietary_Image: [UIImageView]!
    @IBOutlet weak var Dietary_BottomConstrain: NSLayoutConstraint!
    
    public var UserShipping_Address : UserShippingAddress?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialization code
        initialization()
        
        //get food data
        getCategoryList()
        self.Set_Filter_View()
        
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
            
            if self.Sorting_Selection_Index == 2 {
                self.SorttingOnRating()
            } else if self.Sorting_Selection_Index == 3 {
                self.SorttingOnDeliveryTime()
            }else if self.Sorting_Selection_Index == 5 {
    //            self.SorttingOnDeliveryTime() // Picked for you Filter
            }
            UIView.animate(withDuration: 0.3) {
                self.SortView.alpha = 0.0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                
                self.Sort_BottomConstrain.constant = -350.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
        
        @IBAction func Price_Filter_Apply(_ sender: UIButton) {
            
            UIView.animate(withDuration: 0.3) {
                self.PriceView.alpha = 0.0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                
                self.BottomConstrain.constant = -220.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
        
        @IBAction func Delivery_Filter_Apply(_ sender: UIButton) {
            
            UIView.animate(withDuration: 0.3) {
                self.DeliveryView.alpha = 0.0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                
                self.Delivery_BottomConstrain.constant = -220.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
        
        @IBAction func Dietary_Filter_Apply(_ sender: UIButton) {
            
            self.SorttingOnDietary()
            UIView.animate(withDuration: 0.3) {
                self.Dietary.alpha = 0.0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                
                self.Dietary_BottomConstrain.constant = -350.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
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
                
            }, completion: { finished in
                
            })
            
            self.Set_Filter_View()
            
        }
        
        //Delivery Button
        @IBAction func Delivery_Button_Click(_ sender: UIButton) {
            
            for i in 0..<4 {
                
                if Selection_Delivery[i].tag == sender.tag {
                    Selection_Delivery[i].backgroundColor = UIColor.black
                    Selection_Delivery[i].setTitleColor(UIColor.white, for: .normal)
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
                        
                        let index = self.Selected_Diet.index(of: self.Diet_Filter_Name[sender.tag])
                        self.Selected_Diet.remove(at: index!)
                        Selection_Dietary_Image[i].image = nil
                        
                    } else {
                        
                        self.Selected_Diet.append(Diet_Filter_Name[sender.tag])
                        Selection_Dietary_Image[i].image = UIImage(named: "ic_Selected")
                    }
                    
                }
            }
            
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
                    } else {
                        Selection_Price[i].backgroundColor = UIColor.white
                        Selection_Price[i].setTitleColor(UIColor.black, for: .normal)
                    }
                }
            }
        }
    
    func SorttingOnDeliveryTime() {
        
        
    }
    
    func SorttingOnRating() {
        
        
    }
    
    func SorttingOnDeliveryFee() {
        
        
    }
    
    func SorttingOnPrice() {
        
        
    }
    
    func SorttingOnDietary() {
    
    }
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvFoodCategoryList.delegate = self
        cvFoodCategoryList.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: (cvFoodCategoryList.frame.width/2)-15, height: (cvFoodCategoryList.frame.width/2)-15)
//        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        cvFoodCategoryList.collectionViewLayout = layout
        
        //cell for food list collection view
        let nibForSearchBarCell = UINib(nibName: "SearchBarCell", bundle: nil)
        cvFoodCategoryList?.register(nibForSearchBarCell, forCellWithReuseIdentifier: "SearchBarCell")
        let nibForFoodCategoryCell = UINib(nibName: "FoodCategoryCell", bundle: nil)
        cvFoodCategoryList?.register(nibForFoodCategoryCell, forCellWithReuseIdentifier: "FoodCategoryCell")
        
        //setup UIRefreshControll
        self.refreshControl.addTarget(self, action: #selector(FoodCategoryListViewController.reloadData), for: .valueChanged)
        self.cvFoodCategoryList.alwaysBounceVertical = true
        self.cvFoodCategoryList.addSubview(refreshControl)
        self.refreshControl.backgroundColor = .clear
    }
    
    //reload data
    @objc func reloadData(){
        //get category list
        getCategoryList()
    }
    
    //go to food list view controller
    private func loadFoodListViewController(indexPath: IndexPath) -> Void {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let foodListViewController = storyboard.instantiateViewController(withIdentifier: "FoodListViewController") as! FoodListViewController
        foodListViewController.categoryId = foodCategoryList[indexPath.row-1].id
        self.navigationController?.pushViewController(foodListViewController, animated: true)
    }
    
    
    //MARK: API Call
    //get all caetgroy listo
    private func getCategoryList() -> Void {
        
        // TODO: Check API
        
        if isConnectedToNetwork() {
            if !refreshControl.isRefreshing{
                ProgressViewHelper.show(type: .full)
            }
            
            FoodCategoryService.getInstance().getRequest(url: ApiEndpoints.URI_GET_CATEGORY_LIST, completionHandler: { [weak self]
                response in
                ProgressViewHelper.hide()
                if let strongSelf = self {
                    strongSelf.refreshControl.endRefreshing()
                    print("\(strongSelf.CLASS_NAME) -- getCategoryList() -- url = \(ApiEndpoints.URI_GET_CATEGORY_LIST),  response = \(response)")
                    
                    if response.result.isSuccess{
                        let json = JSON(response.data!)
                        //remove all previous data
                        strongSelf.foodCategoryList.removeAll()
                            for item in json["data"].arrayValue{
                                let food = FoodCategory()
                                food.id = item["id"].int
                                food.name = item["name"].string
                                food.url = item["url"].string
                                food.welcomeDescription = item["description"].string
                                food.createdAt = item["createdAt"].string
                                food.updatedAt = item["updatedAt"].string
                                strongSelf.foodCategoryList.append(food)
                        }
                        //reload collection view
                        strongSelf.cvFoodCategoryList.reloadData()
                    } else {
                        strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                        strongSelf.refreshControl.endRefreshing()
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
    
    //Filter
    
    @objc func Click_Filter(sender:UIButton) {
           
           UIView.animate(withDuration: 0.5) {
               sender.transform = sender.transform.rotated(by: CGFloat(M_PI_2 * 2))
               self.view.layoutIfNeeded()
           }
           
           if self.is_FilterPlate {
               self.is_FilterPlate = false
//               self.Reset_Filter()
               self.cvFoodCategoryList.reloadData()
           } else {
               self.is_FilterPlate = true
               self.cvFoodCategoryList.reloadData()
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
    
    @objc func ClickAdd( sender : UIButton) {
        
        if !Helper.isLoggedIn() {
            SnackbarCollection.showSnackbarWithText(text: "Login for add shipping address.")
            return
        }
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShippingAddress") as! ShippingAddress
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: Extension
//MARK: CollectionView
extension FoodCategoryListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodCategoryList.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            if indexPath.row == 0{
                if self.is_FilterPlate {
                    return CGSize(width: cvFoodCategoryList.frame.width, height: 170)
                } else {
                    return CGSize(width: cvFoodCategoryList.frame.width, height: 110)
                }
            } else {
                return CGSize(width: (cvFoodCategoryList.frame.width/2)-5, height: (cvFoodCategoryList.frame.width/2)-5)
            }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for first  cell
        if indexPath.row == 0{
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
            
            cell.addressButton.addTarget(self, action: #selector(self.ClickAdd(sender:)), for: .touchUpInside)
            
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
        //for category  cell
        else {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCategoryCell", for: indexPath) as! FoodCategoryCell
            
            let food = foodCategoryList[indexPath.row-1]
            cell.configureCell(food: food)
            
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //go to food list view controller
        if indexPath.row != 0{
            //go to food list view controller
            loadFoodListViewController(indexPath: indexPath)
        }
    }
    
}

extension FoodCategoryListViewController: SearchBarCellDelegate {
    
    func stop_search() {
        print("123")
    }
    
    func search(text: String) {
        print(text)
    }
}
