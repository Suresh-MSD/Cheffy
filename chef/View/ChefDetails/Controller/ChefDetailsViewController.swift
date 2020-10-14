//
//  ChefDetailsViewController.swift
//  chef
//
//  Created by Eddie Ha on 23/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import Alamofire

class ChefDetailsViewController: BaseViewController {
    //MARK: Properties
    public let  CLASS_NAME = ChefDetailsViewController.self.description()
    open var plateId:Int!
    private var plate: Plate? = nil
    private var relatedPlateList = [Plate]()
    public var itemQuantity = 1
    private let refreshControl = UIRefreshControl()
    private let plateService = PlateService.getInstance()
    var Price = Double()
    
    //MARK: Outlets
    @IBOutlet weak var cvChefDetailsInfo: UICollectionView!
    @IBOutlet weak var uivAddCartContainer: UIView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var lblItemQuantity: UILabel!
    
    static func present(navigationController: UINavigationController?, plateId: Int) {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChefDetailsViewController") as! ChefDetailsViewController
        vc.plateId = plateId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        getPlateDetails(plateId: plateId)
        getRelatedPlateList(plateId: plateId)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: Actions
    //reload data
    @objc func reloadData(){
        //get category list
        getPlateDetails(plateId: plateId)
        getRelatedPlateList(plateId: plateId)
    }
    
    //when tap on add to cart
    @IBAction func onTapAddToCartButton(_ sender: UIButton) {
        addPlateToCart(plateId: plateId)
    }
    
    //when tap on increase item button
    @IBAction func onTapIncreaseItemButton(_ sender: UIButton) {
        itemQuantity += 1
        lblItemQuantity.text = "\(itemQuantity)"
        self.setPlatePrice(price: self.itemQuantity * Int((plate?.price ?? 0)))
    }
    
    //when tap on decrease item button
    @IBAction func ontapDecreaseItemButoon(_ sender: UIButton) {
        if itemQuantity > 0{
            itemQuantity -= 1
            lblItemQuantity.text = "\(itemQuantity)"
            self.setPlatePrice(price: self.itemQuantity * Int((plate?.price ?? 0)))
        }
    }
    
    //Favourite
    
    @objc func Click_Fav(sender:UIButton) {
        
        if sender.image(for: .normal) == UIImage(named: "ic_favorite_checked") {
            
            let url = ApiEndpoints.URI_POST_REMOVE_FAVOURITE+"plate/\(plateId ?? 0)"
            
            plateService.postRemoveFavouriteRequest(url: url) { (response) in
                
                let json = JSON(response.data!)
                print(json["message"])
            }
            
        } else {

            let url = ApiEndpoints.URI_POST_ADD_FAVOURITE
            let parameters = [
                "fav_type": "plate",
                "plateId":"\(plateId ?? 0)"
            ]
            print(parameters)
            plateService.postAddFavouriteRequest(url: url, parameters: parameters) { (response) in


                let json = JSON(response.data!)
                print(json["message"])
            }
        }
        
    }
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        btnAddToCart.elevate(elevation: 10, cornerRadius: 0, color: UIColor.red)
        lblItemQuantity.text = "\(itemQuantity)"
        
        //init collectionviews
        cvChefDetailsInfo.delegate = self
        cvChefDetailsInfo.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cvChefDetailsInfo.frame.width, height: 500)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        cvChefDetailsInfo.collectionViewLayout = layout
        cvChefDetailsInfo.contentInset.top = -UIApplication.shared.statusBarFrame.height
        
        //cell for food list collection view
        let nibChefInfoCell = UINib(nibName: "ChefInfoCell", bundle: nil)
        cvChefDetailsInfo?.register(nibChefInfoCell, forCellWithReuseIdentifier: "ChefInfoCell")
        let nibChefDetailsMainTabCell = UINib(nibName: "ChefDetailsMainTabCell", bundle: nil)
        cvChefDetailsInfo?.register(nibChefDetailsMainTabCell, forCellWithReuseIdentifier: "ChefDetailsMainTabCell")
        let nibForCategoryTitleCell = UINib(nibName: "CategoryTitleCell", bundle: nil)
        cvChefDetailsInfo?.register(nibForCategoryTitleCell, forCellWithReuseIdentifier: "CategoryTitleCell")
        let nibChefDetailsFoodItemCell = UINib(nibName: "ChefDetailsFoodItemCell", bundle: nil)
        cvChefDetailsInfo?.register(nibChefDetailsFoodItemCell, forCellWithReuseIdentifier: "ChefDetailsFoodItemCell")
        
        //setup UIRefreshControll
        self.refreshControl.addTarget(self, action: #selector(ChefDetailsViewController.reloadData), for: .valueChanged)
        self.cvChefDetailsInfo.alwaysBounceVertical = true
        self.cvChefDetailsInfo.addSubview(refreshControl)
        self.refreshControl.backgroundColor = .clear
    }
    
    //set plate price
    private func setPlatePrice(price:Int) -> Void {
        self.Price = Double(price)
        self.btnAddToCart.setTitle("Buy  $\(price)", for: .normal)
    }
    
    //load receipt details  view controller
    private func loadReceiptDetailsViewController() -> Void {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReceiptDetailsViewController") as! ReceiptDetailsViewController
        // TODO: Use PlateType
        vc.plate = self.plate!
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


//MARK: Extension
//MARK: API Call
extension ChefDetailsViewController{
    
    /// post review
    private func postReview(plateId: Int) {
        let url = ApiEndpoints.URI_POST_ORDER_REVIEW + "/\(plateId)/review"
        let parameters: [String: Any] = [
            "orderItemId": 3,
            "rating":5,
            "comment":"Good Review!"
        ]
        plateService.postReviewRequest(url: url, parameters: parameters) { (response) in
            print(response)
        }
    }
    
    //get adetails plate info
    private func getPlateDetails(plateId: Int) -> Void {
        let url = ApiEndpoints.URI_GET_PLATE_DETAILS + "/\(plateId)"
        
        FoodCategoryService.getInstance().getRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                print("\(strongSelf.CLASS_NAME) -- getPlateDetails() -- url = \(url),  response = \(response)")
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    //remove all previous data
                    let item = json["data"].dictionaryValue
                    if !item.isEmpty{
                        let plate = Plate()
                        let chef = item["chef"]!.dictionaryValue
                        plate.id = item["id"]!.int
                        plate.name = item["name"]!.string
                        plate.plateDescription = item["description"]!.string
                        plate.price = Double("\(item["price"]!)")
                  //      plate.featuredImage = item["url"]!.string
                       // plate.distance = item["distance"]!.string
                      //  plate.deliveryType = item["delivery_type"]!.string
                   //     plate.price = item["price"]!.double
                        plate.deliveryTime = item["delivery_time"]!.int
                        plate.chefId = "\(chef["id"]!)"
                        plate.chefName = "\(chef["name"]!)"
                        plate.chefEmail = "\(chef["email"]!)"
                        plate.chefPhoneNo = "\(chef["phone_no"]!)"
                        plate.chefProfilePictureUrl = "\(chef["imagePath"]!)"
                        plate.chefLocation_Lat = "\(chef["location_lat"]!)"
                        plate.chefLocation_Lon = "\(chef["location_lon"]!)"
                        
                        var plateIngredients = [Ingredient]()
                        for plateIngredientsJson in item["Ingredients"]!.arrayValue{
                            var plateIngredient = Ingredient()
                            plateIngredient.name = plateIngredientsJson["name"].string
                            let Full_Date = plateIngredientsJson["purchase_date"].string
                            
                            let dateformat = DateFormatter()
                            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let date = dateformat.date(from: Full_Date ?? "")
                            dateformat.dateFormat = "dd-MM-yyyy"
                            let String_Date = dateformat.string(from: date!)
                            
                            plateIngredient.purchase_date = String_Date
                            plateIngredients.append(plateIngredient)
                            
                        }
                        plate.ingredientList = plateIngredients
                      //  plate.rating = item["rating"]!.int
                        
                        //make plateImages
                        var plateImageList = [PlateImage]()
                        
                        for plateImageJson in item["PlateImages"]!.arrayValue{
                            var plateImage = PlateImage()
                            plateImage.name = plateImageJson["name"].string
                            plateImage.url = plateImageJson["url"].string
                            plateImageList.append(plateImage)
                        }
                        
                        plate.plateImageList = Optional(plateImageList)
                        
                        var ReceiptImageList = [ReceiptImage]()
                        
                        for ReceiptImageJson in item["ReceiptImages"]!.arrayValue{
                            var Receipt_Image = ReceiptImage()
                            Receipt_Image.name = ReceiptImageJson["name"].string
                            Receipt_Image.url = ReceiptImageJson["url"].string
                            ReceiptImageList.append(Receipt_Image)
                        }
                        plate.receiptImageList = Optional(ReceiptImageList)
                        
                        //make Review
                        var plateReviewList = [PlateReview]()
                        
                        for plateReviewJson in item["reviews"]!.arrayValue{
                        
                            let Plate_Review = PlateReview()
                            Plate_Review.comment = plateReviewJson["comment"].stringValue
                            Plate_Review.rating = plateReviewJson["rating"].stringValue
                            Plate_Review.reviewdate = plateReviewJson["createdAt"].stringValue
                            
                            let Review_User_Data = plateReviewJson["user"].dictionaryValue
                            var User_data = User()
                            User_data.email = Review_User_Data["email"]?.stringValue
                            User_data.id = Review_User_Data["id"]?.int
                            User_data.imagePath = Review_User_Data["imagePath"]?.stringValue
                            User_data.name = Review_User_Data["name"]?.stringValue
                            Plate_Review.user = User_data
                            
                            plateReviewList.append(Plate_Review)
                        }
                        plate.plateReviewList = Optional(plateReviewList)
                        
                        plate.plateReviewList = Optional(plateReviewList)
                        print(plate.plateReviewList!.count)
                        strongSelf.plate = plate

                    }
                    //reload collection view
                    DispatchQueue.main.async {
                        strongSelf.cvChefDetailsInfo.reloadData()
                        if strongSelf.plate != nil {
                            strongSelf.setPlatePrice(price: strongSelf.itemQuantity * Int((strongSelf.plate!.price ?? 0)))
                        }
                    }
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
    
    
    //get all related plate  list
    private func getRelatedPlateList(plateId: Int) -> Void {
        let url = "\(ApiEndpoints.URI_GET_PLATE_LIST)/\(plateId)/related"
        
        PlateService.getInstance().getRelatedPlateListRequest(url: url, completionHandler: {response in
            
            print("\(self.CLASS_NAME) -- getRelatedPlateList() -- response = \(response)")
            
            if response.result.isSuccess{
                let json = JSON(response.data!)
                
                //remove all previous data
                self.relatedPlateList.removeAll()
                for plateJson in json["data"].arrayValue{
                    let plate = Plate()
                    plate.id = plateJson["id"].int
                    plate.name = plateJson["name"].string
                    plate.plateDescription = plateJson["description"].string
                    plate.distance = plateJson["distance"].string
                    plate.deliveryType = plateJson["delivery_type"].string
                    plate.price = plateJson["price"].double
                    plate.deliveryTime = plateJson["delivery_time"].int
                    plate.rating = plateJson["rating"].double
                    
                    //make plateImages
                    var plateImageList = [PlateImage]()
                    
                    for plateImageJson in plateJson["PlateImages"].arrayValue{
                        var plateImage = PlateImage()
                        plateImage.name = plateImageJson["name"].string
                        plateImage.url = plateImageJson["url"].string
                        plateImageList.append(plateImage)
                    }
                    
                    plate.featuredImage = plateImageList.first?.url
                    plate.plateImageList = Optional(plateImageList)
                    
                    //append food list
                    self.relatedPlateList.append(plate)
                }
                
                //reload collection view
                self.refreshControl.endRefreshing()
                self.cvChefDetailsInfo.reloadData()
            }
        })
    }
    
    
    //add plate to cart request
    private func addPlateToCart(plateId: Int) -> Void {
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Receipt_Special_Instruction_VC") as! Receipt_Special_Instruction_VC
//        vc.plateId = plateId
        vc.Cart_Plate = self.plate ?? Plate()
        vc.Quntity = itemQuantity
        vc.Total_price = self.Price
        navigationController?.pushViewController(vc, animated: true)
        
//        if !Helper.isLoggedIn() {
//            SnackbarCollection.showSnackbarWithText(text: "Login to Add To Cart.")
//            return
//        }
//
//        let url = "\(ApiEndpoints.URI_ADD_PLATE_TO_CART)"
//
//        let Item_Array = [["quantity":itemQuantity,"plateId":plateId]]
//        let parameter = ["plates":Item_Array]
//
//        CartService.getInstance().addPlateToCartRequest(url: url, parameters: parameter , completionHandler: {response in
//
//            print("\(self.CLASS_NAME) -- addPlateToCart() -- response = \(response)")
//
//            if response.result.isSuccess {
//                //                let json = JSON(response.data!)
//                SnackbarCollection.showSnackbarWithText(text: "Added this plate to your cart successfully")
//            }
//        })
    }
}


//MARK: CollectionView
extension ChefDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedPlateList.count+3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for header cell
        if indexPath.row == 0{
            return CGSize(width: cvChefDetailsInfo.frame.width, height: 350)
        }
            
        //if main tab bar cell
        else if indexPath.row == 1{
            return CGSize(width: cvChefDetailsInfo.frame.width, height: 475)
        }
        
        //if category title cell
        else if indexPath.row == 2{
            return CGSize(width: cvChefDetailsInfo.frame.width, height: 35)
        }
        
        //if food item cell
        else{
            return CGSize(width: cvChefDetailsInfo.frame.width, height: 160)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for header cell
        if indexPath.row == 0{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ChefInfoCell", for: indexPath) as! ChefInfoCell
            
             populateChefInfoCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
        
        //for main tab bar  cell
        else if indexPath.row == 1{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ChefDetailsMainTabCell", for: indexPath) as! ChefDetailsMainTabCell
           
            cell.delegate = self
            populateMainTabCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
        
        //for category cell
        else if indexPath.row == 2{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryTitleCell", for: indexPath) as! CategoryTitleCell
            
            populateCategoryTitleCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
        
            //for food item cell
        else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ChefDetailsFoodItemCell", for: indexPath) as! ChefDetailsFoodItemCell
            
            populateFoodItemCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
        
    }
    
    //populet chef info cell
    private func populateChefInfoCell(cell: ChefInfoCell, indexPath: IndexPath) -> ChefInfoCell{
        
        if plate?.chefLocation_Lat != "" {
            getAddressFromLatLon(pdblLatitude: plate?.chefLocation_Lat ?? "", withLongitude: plate?.chefLocation_Lon ?? "", completionHandler: { (address) in
                cell.lblLabel.text = address
            })
        }
        
        cell.lblName.text = plate?.chefName?.capitalizingFirstLetter()
        cell.lblRating.text = "\(plate?.rating ?? 0)"
        cell.lblTimeline.text = "\(plate?.deliveryTime ?? 0) - \((plate?.deliveryTime ?? 0) + 5) min"
        cell.lblActionType.text = "Delivery"
        if let chefProfileImage = plate?.chefProfilePictureUrl {
            cell.ivProfilePicture.setImageFromUrl(url: chefProfileImage)
        }
        
        cell.uivProfilePictureContainer.elevate(elevation: 5, cornerRadius: 5)
        Helper.maskView(cell.ivProfilePicture, topLeftRadius: 5, bottomLeftRadius: 5, bottomRightRadius: 5, topRightRadius: 5, width: cell.ivProfilePicture.frame.width, height: cell.ivProfilePicture.frame.height)
        cell.plateImages = plate?.plateImageList ?? [PlateImage]()
        cell.delegate = self
        
        cell.btnFav.isHidden = Helper.isLoggedIn() ? false : true
        cell.btnFav.addTarget(self, action: #selector(self.Click_Fav(sender:)), for: .touchUpInside)
        cell.btnFav.tag = 1000 + indexPath.row
        
        return cell
    }
    
    //populet chef main tab  cell
    private func populateMainTabCell(cell: ChefDetailsMainTabCell, indexPath: IndexPath) -> ChefDetailsMainTabCell{
        if let plate = self.plate {
            cell.plate = plate
        }
        return cell
    }
    
    //populet chef category title  cell
    private func populateCategoryTitleCell(cell: CategoryTitleCell, indexPath: IndexPath) -> CategoryTitleCell{
        
        cell.lblCategoryName.text = "Related Plate"
        
        return cell
    }
    
    //populet chef food item  cell
    private func populateFoodItemCell(cell: ChefDetailsFoodItemCell, indexPath: IndexPath) -> ChefDetailsFoodItemCell{
        
        let relatedPlate = relatedPlateList[indexPath.row-3]
        cell.lblTitle.text = relatedPlate.name?.capitalizingFirstLetter()
        cell.lblDescription.text = relatedPlate.plateDescription?.capitalizingFirstLetter()
        cell.lblPrice.text = "\(relatedPlate.price ?? 0)"
        cell.lblDeliveryTime.text = "\(relatedPlate.deliveryTime ?? 0) min"
        cell.lblDeliveryType.text = "Delivery"
        
        if relatedPlate.plateImageList?.count ?? 0 > 0 {
            cell.ivFetauredImage.setImageFromUrl(url: relatedPlate.plateImageList?[0].url ?? "")
        }
        
        //show /hide free button
        let Delivery_Type = relatedPlate.deliveryType
        
        if Delivery_Type == "free" {
            cell.btnOffer.isHidden = false
        } else {
            cell.btnOffer.isHidden = true
        }
        
        return cell
    }
    
}


//MARK: delegates
//MARK: ChefDetailsNestedTabDetailsCellDelegate
extension ChefDetailsViewController : ChefInfoCellDelegate{
    //when click on back button
    func onClickBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: ChefDetailsNestedTabDetailsCellDelegate
extension ChefDetailsViewController : ChefDetailsNestedTabDetailsCellDelegate{
    //when click on view all receipt
    func onClickViewAllReceipt() {
        loadReceiptDetailsViewController()
    }
}

