//
//  ChefProfileViewController.swift
//  chef
//
//  Created by Eddie Ha on 27/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ChefProfileViewController: UIViewController {

    //MARK: Properties
    public let CLASS_NAME = UserProfileViewController.self.description()
    private var profileItemList = [ProfileItem]()
    
    //MARK: Outlets
    @IBOutlet weak var cvChefProfile: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialization
        initialization()
    }
    
    //MARK Actions
    //when click on back button
    @IBAction func onClickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        //get profile menu item
        profileItemList = getProfileMenuData()
        
        //init collectionviews
        cvChefProfile.delegate = self
        cvChefProfile.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: (cvChefProfile.frame.width/2)-5, height: 240)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        cvChefProfile.collectionViewLayout = layout
        
        //cell for food list collection view
        let nibUserProfileTopCell = UINib(nibName: "UserProfileTopCell", bundle: nil)
        cvChefProfile?.register(nibUserProfileTopCell, forCellWithReuseIdentifier: "UserProfileTopCell")
        let nibUserProfileTabCell = UINib(nibName: "UserProfileTabCell", bundle: nil)
        cvChefProfile?.register(nibUserProfileTabCell, forCellWithReuseIdentifier: "UserProfileTabCell")
        let nibAccountSettingsCell = UINib(nibName: "AccountSettingsCell", bundle: nil)
        cvChefProfile?.register(nibAccountSettingsCell, forCellWithReuseIdentifier: "AccountSettingsCell")
    }
    
    //get profile menu data source
    private func getProfileMenuData() -> [ProfileItem]{
        var profileItems = [ProfileItem]()
        
        let menu1 = ProfileItem()
        menu1.name = Optional("Status")
        menu1.image = Optional("ic_account_black")
        menu1.type = Optional("profile")
        
        profileItems.append(menu1)
        
        let menu2 = ProfileItem()
        menu2.name = Optional("Payment")
        menu2.image = Optional("ic_shipping_black")
        menu2.type = Optional("profile")
        
        profileItems.append(menu2)
        
        let menu3 = ProfileItem()
        menu3.name = Optional("Chef Profile Edit")
        menu3.image = Optional("ic_payment_black")
        menu3.type = Optional("profile")
        
        profileItems.append(menu3)
        
        return profileItems
    }
    
    //get settings menu data source
    private func getSettingsMenuData() -> [ProfileItem]{
        var profileItems = [ProfileItem]()
        
        let menu1 = ProfileItem()
        menu1.name = Optional("Profile Edit")
        menu1.image = Optional("ic_account_black")
        menu1.type = Optional("settings")
        
        profileItems.append(menu1)
        
        let menu2 = ProfileItem()
        menu2.name = Optional("Contact Support")
        menu2.image = Optional("ic_shipping_black")
        menu2.type = Optional("settings")
        
        profileItems.append(menu2)
        
        let menu3 = ProfileItem()
        menu3.name = Optional("Legal")
        menu3.image = Optional("ic_payment_black")
        menu3.type = Optional("settings")
        
        profileItems.append(menu3)
        
        let menu4 = ProfileItem()
        menu4.name = Optional("Logout")
        menu4.image = Optional("ic_logout_black")
        menu4.type = Optional("settings")
        
        profileItems.append(menu4)
        
        return profileItems
    }
    
    //go to chef details view controller
    private func loadUserProfileEditViewController() -> Void {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserProfileEditViewController") as! UserProfileEditViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //go to chef details view controller
    private func loadChefStatusViewController() -> Void {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChefStatusViewController") as! ChefStatusViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


//MARK: Extension
//MARK: CollectionView
extension ChefProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileItemList.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0{
            return CGSize(width: cvChefProfile.frame.width, height: 275)
        }
            
            //for FoodListWithCategoryCell
        else if indexPath.row == 1{
            return CGSize(width: cvChefProfile.frame.width, height: 60)
        }
            
            
            //for FoodItemCell
        else{
            if (profileItemList[indexPath.row - 2].type ?? "").elementsEqual("profile") {
                return CGSize(width: (cvChefProfile.frame.width), height: 50)
            }else{
                return CGSize(width: (cvChefProfile.frame.width), height: 50)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for profile   cell
        if indexPath.row == 0{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileTopCell", for: indexPath) as! UserProfileTopCell
            
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
            
            //check if profile  menu item
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "AccountSettingsCell", for: indexPath) as! AccountSettingsCell
                
            let menu = profileItemList[indexPath.row-2]
            cell.lblMenuTitle.text = menu.name
            cell.ivMenuIcon.image = UIImage(named: menu.image!)
            
            return  cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.row == 2 {
            if (profileItemList[indexPath.row - 2].type ?? "").elementsEqual("settings"){
                loadUserProfileEditViewController()
            }else if (profileItemList[indexPath.row - 2].type ?? "").elementsEqual("profile"){
                loadChefStatusViewController()
            }
        }
    }
    
}


//MARK: UserProfileTabCellDelegate
extension ChefProfileViewController: UserProfileTabCellDelegate {
    func onClickTabItem(position: Int, name: String, type: String) {
        if position == 1{
            self.profileItemList = getProfileMenuData()
            cvChefProfile.reloadData()
        }else{
            self.profileItemList = getSettingsMenuData()
            cvChefProfile.reloadData()
        }
    }
}
