//
//  UserProfileViewController.swift
//  chef
//
//  Created by Eddie Ha on 27/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyJSON
import Kingfisher

class UserProfileViewController: BaseViewController {
    
    //MARK: Properties
    public let CLASS_NAME = UserProfileViewController.self.description()
    private var profileItemList = [ProfileItem]()
    fileprivate var user = User()
    fileprivate var favList = [Plate]()
    
    var is_Fav = true
    
    //MARK: Outlets
    @IBOutlet weak var cvUserProfile: UICollectionView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        getUserProfile()
        getFavouritePlateList()
        subscribeStateUpdate()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeStateUpdate()
    }
    
    //MARK: Intsance Method
    private func initialization() -> Void {
        
        //init collectionviews
        cvUserProfile.delegate = self
        cvUserProfile.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: (cvUserProfile.frame.width/2)-5, height: 240)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        cvUserProfile.collectionViewLayout = layout
        
        //cell for food list collection view
        let nibUserProfileTopCell = UINib(nibName: "UserProfileTopCell", bundle: nil)
        cvUserProfile?.register(nibUserProfileTopCell, forCellWithReuseIdentifier: "UserProfileTopCell")
        let nibUserProfileTabCell = UINib(nibName: "UserProfileTabCell", bundle: nil)
        cvUserProfile?.register(nibUserProfileTabCell, forCellWithReuseIdentifier: "UserProfileTabCell")
        let nibFoodItemCell = UINib(nibName: "ProfileFoodItemCell", bundle: nil)
        cvUserProfile?.register(nibFoodItemCell, forCellWithReuseIdentifier: "ProfileFoodItemCell")
        let nibAccountSettingsCell = UINib(nibName: "AccountSettingsCell", bundle: nil)
        cvUserProfile?.register(nibAccountSettingsCell, forCellWithReuseIdentifier: "AccountSettingsCell")
    }
    
    //get menu data source
    private func getMenuData() -> [ProfileItem]{
        var profileItems = [ProfileItem]()
        
        let menu1 = ProfileItem()
        menu1.name = Optional("Account Edit")
        menu1.image = Optional("ic_account_black")
        menu1.type = Optional("settings")
        
        profileItems.append(menu1)
        
        let menu2 = ProfileItem()
        menu2.name = Optional("Shipping")
        menu2.image = Optional("ic_shipping_black")
        menu2.type = Optional("settings")
        
        profileItems.append(menu2)
        
        let menu3 = ProfileItem()
        menu3.name = Optional("Payment")
        menu3.image = Optional("ic_payment_black")
        menu3.type = Optional("settings")
        
        profileItems.append(menu3)
        
        let menu4 = ProfileItem()
        menu4.name = Optional("Password")
        menu4.image = Optional("ic_lock")
        menu4.type = Optional("settings")
        
        profileItems.append(menu4)
        
        
        let menu5 = ProfileItem()
        menu5.name = Optional("Contact Support")
        //        menu4.image = Optional("ic_payment_black")
        menu5.type = Optional("settings")
        
        profileItems.append(menu5)
        
        let menu6 = ProfileItem()
        menu6.name = Optional("Legal")
        //        menu5.image = Optional("ic_payment_black")
        menu6.type = Optional("settings")
        
        profileItems.append(menu6)
        
        let menu7 = ProfileItem()
        menu7.name = Optional("Logout")
        menu7.image = Optional("ic_logout_black")
        menu7.type = Optional("settings")
        
        profileItems.append(menu7)
        
        return profileItems
    }
    
    //go to user edit view controller
    private func loadUserProfileEditViewController() -> Void {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserProfileEditViewController") as! UserProfileEditViewController
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //go to chef proile view controller
    private func loadChefProfileEditViewController() -> Void {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChefProfileViewController") as! ChefProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //load  user payment view controller
    private func loadUserPaymentViewController() -> Void {
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserCardListVC") as! UserCardListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //load  user Change Password view controller
    private func loadUserChangePasswordViewController() -> Void {
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Password_Verify_VC") as! Password_Verify_VC
        vc.Current_user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //load  Contact view controller
    private func loadContactViewController() -> Void {
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Contact_Support_VC") as! Contact_Support_VC
//        vc.Current_user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //load  user shipping view controller
    private func loadUserShippingViewController() -> Void {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShippingAddress") as! ShippingAddress
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //load  user payment view controller
    private func loadPasswordController() -> Void {
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserCardListVC") as! UserCardListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:
    //MARK:- API Call
    private func getUserProfile()  {
        ProgressViewHelper.show(type: .full)
        
        let url = ApiEndpoints.URI_GET_USERPROFILE
        
        UserProfileService.getInstance().getUserProfile(url: url, completionHandler: { [weak self]
            response in
            
            ProgressViewHelper.hide()
            if let strongSelf = self {
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    //remove all previous data
                    print(json)
                    var address = ""
                    if let data = json["data"].dictionary{
                        strongSelf.user.phone_no = data["phone_no"]?.string
                        strongSelf.user.name = data["name"]?.string
                        strongSelf.user.imagePath = data["imagePath"]?.string
                        strongSelf.user.email = data["email"]?.string
                        if((data["address"]?.array!.count)!>0)
                        {
                            let defaultAddress = data["address"]?.array?.filter{$0["isDefaultAddress"].boolValue}[0]
                            address = "\((defaultAddress?.dictionary!["addressLine1"]?.string) ?? "")  \((defaultAddress?.dictionary!["addressLine2"]?.string) ?? "") \((defaultAddress?.dictionary!["city"]?.string) ?? "") \((defaultAddress?.dictionary!["state"]?.string) ?? "")"
                        }
                        strongSelf.user.defaultAddress = address
                        
                        self?.cvUserProfile.reloadData()
                    }
                } else {
                    
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
    
    
    private func getFavouritePlateList()  {
        
        ProgressViewHelper.show(type: .full)
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
                    
                    for item in json["data"].arrayValue{
                        strongSelf.favList.append(strongSelf.getFavouritePlateObject(item: item["Plate"]))
                    }
                    print(strongSelf.favList)
                    //reload collection view
                    strongSelf.cvUserProfile.reloadData()
                } else {
                    
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
    
    
    private func getFavouritePlateObject(item : JSON)->Plate{
        
        let Popularplate = Plate()
        if let plate_id = item["plate_id"].int{
            Popularplate.id = plate_id
        }else  if let id = item["id"].int{
            Popularplate.id = id
        }
        
        Popularplate.rating = item["rating"].double
        Popularplate.name = item["name"].string
        Popularplate.plateDescription = item["description"].string
        Popularplate.price = item["price"].double
        Popularplate.deliveryTime = item["delivery_time"].int
        Popularplate.deliveryType = item["delivery_type"].string
        
        var plateImageList = [PlateImage]()
        
        for plateImageJson in item["PlateImages"].arrayValue{
            var plateImage = PlateImage()
            plateImage.name = plateImageJson["name"].string
            plateImage.url = plateImageJson["url"].string
            plateImageList.append(plateImage)
        }
        Popularplate.plateImageList = plateImageList
        return Popularplate
    }
    
    @objc func Click_UnfavPlate( sender : UIButton) {
        
        let plateId = self.favList[sender.tag].id ?? 0
        let url = ApiEndpoints.URI_POST_REMOVE_FAVOURITE+"plate/\(plateId)"
        
        PlateService.getInstance().postRemoveFavouriteRequest(url: url) { (response) in
            
            let _ = JSON(response.data!)
            self.getFavouritePlateList()
        }
    }
}


// MARK: CollectionViewDelegate
extension UserProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if is_Fav {
//            if favList.isEmpty {
//                collectionView.setEmptyMessage("Favorite items appear here")
//            } else {
//                collectionView.restore()
//            }
//        }
        return is_Fav ? favList.count + 2 : profileItemList.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0{
            return CGSize(width: cvUserProfile.frame.width, height: 275)
        }
            
            //for FoodListWithCategoryCell
        else if indexPath.row == 1{
            return CGSize(width: cvUserProfile.frame.width, height: 60)
        }
            
            
            //for FoodItemCell
        else{
            if is_Fav {
                return CGSize(width: ( cvUserProfile.frame.width / 2 ) - 5, height: 230)
            }else{
                return CGSize(width: (cvUserProfile.frame.width), height: 50)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for profile   cell
        if indexPath.row == 0{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileTopCell", for: indexPath) as! UserProfileTopCell
            cell.delegate = self
            
            cell.set(user: self.user)
            
            return cell
        }
            
            //for tab  cell
        else if indexPath.row == 1{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileTabCell", for: indexPath) as! UserProfileTabCell
            cell.delegate = self 
            return cell
        }
            
            //for food item  cell
        else{
            
            //check if profile item is food
            if is_Fav {
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFoodItemCell", for: indexPath) as! ProfileFoodItemCell
                
                
                if self.favList.count > indexPath.row - 2{
                    cell.setFavoriteData(model: self.favList[indexPath.row - 2])
                }
                
                cell.ivFeatureImage.layer.cornerRadius = 10
                cell.ivFeatureImage.clipsToBounds = true
                cell.ivFeatureImage.layer.borderColor = UIColor.lightGray.cgColor
                cell.ivFeatureImage.layer.shadowColor = UIColor.black.cgColor
                cell.ivFeatureImage.layer.shadowOpacity = 0.5
                cell.ivFeatureImage.layer.shadowRadius = 10.0
                cell.ivFeatureImage.layer.shadowOffset = CGSize(width: 1, height: 1)
                
                cell.uivFeaturedImageContainer.elevate(elevation: 6, cornerRadius: 15)
                cell.btnFav.tag = indexPath.row - 2
                cell.btnFav.addTarget(self, action: #selector(self.Click_UnfavPlate(sender:)), for: .touchUpInside)
                
                return cell
            }else{
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "AccountSettingsCell", for: indexPath) as! AccountSettingsCell
                
                let menu = profileItemList[indexPath.row-2]
                cell.lblMenuTitle.text = menu.name
                
                if menu.name == "Contact Support" || menu.name == "Legal" {
                    cell.ivMenuIcon.image = nil
                    cell.img_width_contraint.constant = 0.0
                    cell.spacing_constraint.constant = 0.0
                } else {
                    cell.ivMenuIcon.image = UIImage(named: menu.image!)
                    cell.img_width_contraint.constant = 17.0
                    cell.spacing_constraint.constant = 10.0
                }
                
                return  cell 
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if is_Fav {
            
            if !favList.isEmpty {
                let plate = favList[indexPath.row-2]
                ChefDetailsViewController.present(navigationController: self.navigationController, plateId: plate.id ?? 0)
            }
            
        } else {
            
            switch(indexPath.row) {
            case 2:
                if (profileItemList[indexPath.row - 2].type ?? "").elementsEqual("settings"){
                    loadUserProfileEditViewController()
                }
            case 3:
                if (profileItemList[indexPath.row - 2].type ?? "").elementsEqual("settings"){
                    loadUserShippingViewController()
                }
            case 4:
                if (profileItemList[indexPath.row - 2].type ?? "").elementsEqual("settings"){
                    loadUserPaymentViewController()
                }
            case 5:
                if (profileItemList[indexPath.row - 2].type ?? "").elementsEqual("settings"){
                    loadUserChangePasswordViewController()
                }
            case 6:
                if (profileItemList[indexPath.row - 2].type ?? "").elementsEqual("settings"){
                    loadContactViewController()
                }
            
            case 8:
                if (profileItemList[indexPath.row - 2].type ?? "").elementsEqual("settings"){
                    logout()
                }
                
            default: break
            }
        }
    }
}


//MARK: UserProfileTabCellDelegate
extension UserProfileViewController: UserProfileTabCellDelegate {
    func onClickTabItem(position: Int, name: String, type: String) {
        if type.elementsEqual("favorite"){
            is_Fav = true
            cvUserProfile.reloadData()
        }else{
            is_Fav = false
            profileItemList = getMenuData()
            cvUserProfile.reloadData()
        }
    }
}

//MARK: UserProfileTopCellDelegate
extension UserProfileViewController:  UserProfileTopCellDelegate{
    func onClickChangeProfilePictureButton() {
        loadChefProfileEditViewController()
    }
}

//MARK: StoreSubscriber
extension UserProfileViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = User?
    
    func subscribeStateUpdate() {
        store.subscribe(self) { subcription in
            subcription.select { state in state.loginUser }
        }
        newState(state: store.state.loginUser)
    }
    
    func unsubscribeStateUpdate() {
        store.unsubscribe(self)
    }
    
    func newState(state: User?) {
        cvUserProfile.reloadData()
    }
    
    func logout() {
        let alert: UIAlertController = UIAlertController(title: "Logout", message: "Are you sure you want to Logout?", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            store.dispatch(Actions.logout())
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
