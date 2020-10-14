//
//  CartViewController.swift
//  chef
//
//  Created by Eddie Ha on 17/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import ReSwift

class CartViewController: BaseViewController {
    
    //MARK: Properties
    public let CLASS_NAME = CartViewController.self.description()
    private var tabItemList = ["Add Cart", "Custom Order", "Tracking Order", "Delivery Complete"]
    private var addcartItemList = [CartItem]()
    private var trackingCartItemList = [CartItem]()
    private var customOrderCartItemList = [CartItem]()
    private var deliveryCompleteCartItemList = [CartItem]()
    private var selectedIndxPath = IndexPath(row: 0, section: 0)
    private let refreshControl = UIRefreshControl()
    
    
//    private var basketItems = [BasketItem]()
    private var basketData: BasketModel?
    
    //MARK: Outlets
    @IBOutlet weak var cvTabBar: UICollectionView!
    @IBOutlet weak var cvTabDetails: UICollectionView!
    @IBOutlet weak var Bottom_View: UIView!
    @IBOutlet weak var lbltotalPrice: UILabel!
    @IBOutlet weak var btnItemCount: UIButton!
    @IBOutlet weak var No_Data_Image: UIImageView!
    @IBOutlet weak var No_Data_Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        if isConnectedToNetwork() {
            /// APi's Here should be called seprate with screen state => will refactor it.
            getBasketData()
            getCartOrderList()
            getTrackingCartOrderList()
            getDeliveryCompleteCartOrderList()
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }

        subscribeStateUpdate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unsubscribeStateUpdate()
    }
    
    //MARK: Actions
    @IBAction func onTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //when tap on view item cart
    @IBAction func onTapviewItemcart(_ sender: UITapGestureRecognizer) {
    let vc = storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        vc.cartItemData = basketData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //reload data
    @objc func reloadData(){
        //get cart list
        getCartOrderList()
        getTrackingCartOrderList()
        getDeliveryCompleteCartOrderList()
    }
    
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvTabBar.delegate = self
        cvTabBar.dataSource = self
        cvTabDetails.delegate = self
        cvTabDetails.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        layout.itemSize = CGSize(width: (cvTabBar.frame.width/2)-15, height: (cvTabBar.frame.width/2)-15)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        cvTabBar.collectionViewLayout = layout
        
        //cell for food list collection view
        cvTabBar?.register(UINib(nibName: "CartTabBarCell", bundle: nil), forCellWithReuseIdentifier: "CartTabBarCell")
        cvTabDetails?.register(UINib(nibName: "CartAddTabDetailsCell", bundle: nil), forCellWithReuseIdentifier: "CartAddTabDetailsCell")
        cvTabDetails?.register(UINib(nibName: "CartCustomOrderTabDetailsCell", bundle: nil), forCellWithReuseIdentifier: "CartCustomOrderTabDetailsCell")
        cvTabDetails?.register(UINib(nibName: "CartTrackingOrderTabDetailsCell", bundle: nil), forCellWithReuseIdentifier: "CartTrackingOrderTabDetailsCell")
        cvTabDetails?.register(UINib(nibName: "CartDeliveryCompleteTabDetailsCell", bundle: nil), forCellWithReuseIdentifier: "CartDeliveryCompleteTabDetailsCell")
        
        
        //setup UIRefreshControll
        self.refreshControl.addTarget(self, action: #selector(CartViewController.reloadData), for: .valueChanged)
        self.cvTabDetails.alwaysBounceVertical = true
        self.cvTabDetails.addSubview(refreshControl)
        self.refreshControl.backgroundColor = .clear
    }
    
    
}


//MARK: Extension
//MARK: API Call
extension CartViewController{
    
    // Get Basket List
    
    func getBasketData() {
        ProgressViewHelper.show(type: .full)
        BasketRequest().exec { [weak self]
            (result, error) in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                
                if result?.items?.count ?? 0 == 0 {
                    self?.Bottom_View.isHidden = true
                } else {
                    self?.Bottom_View.isHidden = false
                }
                
                if let basket = result, let basketItems = result?.items {
                    strongSelf.basketData = basket
                    strongSelf.lbltotalPrice.text = "$ \( basket.total ?? 0)"
                    strongSelf.btnItemCount.setTitle("\(basketItems.count)", for: .normal)
                    strongSelf.cvTabDetails.reloadData()
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        }
    }
    
    
    //get all cart order list for add cart section
    private func getCartOrderList() -> Void {
        
        let url = "\(ApiEndpoints.URI_GET_ADD_CART_ITEM_LIST)"
        
        ProgressViewHelper.show(type: .full)
        // TODO: Check API
        CartService.getInstance().getCartItemListRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                print("\(strongSelf.CLASS_NAME) -- getCartOrderList() -- url = \(url),  response = \(response)")
                
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    //remove all previous data
                    strongSelf.addcartItemList.removeAll()
                    for cartJson in json["data"].arrayValue{
                        for cartJson in cartJson["OrderItems"].arrayValue{
                            let plate = CartItem()
                            plate.id = cartJson["BasketId"].int
                            plate.name = cartJson["plate"]["name"].string
                            plate.price = cartJson["plate"]["price"].int
                            for plateImageJson in cartJson["plate"]["PlateImages"].arrayValue{
                                plate.featuredImage = plateImageJson["url"].string
                                break
                            }
                            strongSelf.addcartItemList.append(plate)
                            //                        self.trackingCartItemList.append(plate)
                            strongSelf.customOrderCartItemList.append(plate)
                            //                        self.deliveryCompleteCartItemList.append(plate)
                        }
                    }
                    //reload collection view
                    strongSelf.cvTabDetails.reloadData()
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
    
    
    //get order list for tracking
    private func getTrackingCartOrderList() -> Void {
        let url = "\(ApiEndpoints.URI_GET_TRACKING_CART_ITEM_LIST)"
        
        ProgressViewHelper.show(type: .full)
        // TODO: Check API
        CartService.getInstance().getCartItemListRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                print("\(strongSelf.CLASS_NAME) -- getTrackingCartOrderList() -- url = \(url),  response = \(response)")

                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    
                    //remove all previous data
                    strongSelf.trackingCartItemList.removeAll()
                    
                    for cartJson in json["data"].arrayValue{
                        for cartJson in cartJson["OrderItems"].arrayValue{
                            let plate = CartItem()
                            plate.id = cartJson["BasketId"].int
                            plate.name = cartJson["plate"]["name"].string
                            plate.price = cartJson["plate"]["price"].int
                            
                            for plateImageJson in cartJson["plate"]["PlateImages"].arrayValue{
                                plate.featuredImage = plateImageJson["url"].string
                                break
                            }
                            
                            strongSelf.trackingCartItemList.append(plate)
                        }
                    }
                    
                    //reload collection view
                    strongSelf.cvTabDetails.reloadData()
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }

    
    //get order list for delivery complete
    private func getDeliveryCompleteCartOrderList() -> Void {
        let url = "\(ApiEndpoints.URI_GET_DELIVERY_COMPLETE_CART_ITEM_LIST)"
        
        ProgressViewHelper.show(type: .full)
        CartService.getInstance().getCartItemListRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                print("\(strongSelf.CLASS_NAME) -- getDeliveryCompleteCartOrderList() -- url = \(url),  response = \(response)")
                
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    
                    //remove all previous data
                    strongSelf.trackingCartItemList.removeAll()
                    
                    for cartJson in json["data"].arrayValue{
                        for cartJson in cartJson["OrderItems"].arrayValue{
                            let plate = CartItem()
                            plate.id = cartJson["BasketId"].int
                            plate.name = cartJson["plate"]["name"].string
                            plate.price = cartJson["plate"]["price"].int
                            
                            for plateImageJson in cartJson["plate"]["PlateImages"].arrayValue{
                                plate.featuredImage = plateImageJson["url"].string
                                break
                            }
                            
                            strongSelf.deliveryCompleteCartItemList.append(plate)
                        }
                    }
                    strongSelf.cvTabDetails.reloadData()
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }

    func ChangeCountBasket(url: String) {

        ProgressViewHelper.show(type: .full)
        CartService.getInstance().changeBasketCountRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                print("\(strongSelf.CLASS_NAME) -- changeBasketCountRequest() -- url = \(url),  response = \(response)")
                if response.result.isSuccess {
                    strongSelf.getBasketData()
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }

    func PlateDeleteFromBasket(url: String) {
        
        ProgressViewHelper.show(type: .full)
        CartService.getInstance().deleteBasketRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                print("\(strongSelf.CLASS_NAME) -- deleteBasketRequest() -- url = \(url),  response = \(response)")
                if response.result.isSuccess {
                    strongSelf.getBasketData()
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("Scroll End")
    }
}


//MARK: CollectionView
extension CartViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 100{
            let slide = round(scrollView.contentOffset.x/cvTabDetails.frame.width)
            selectedIndxPath = IndexPath(row: Int(slide), section: 0)
            cvTabBar.scrollToItem(at: selectedIndxPath, at: .centeredHorizontally, animated: true)
            cvTabBar.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tabItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for tab bar cell
        if collectionView.isEqual(cvTabBar){
            return CGSize(width: Helper.getTextWidth(text: tabItemList[indexPath.row], height: 40)+40, height: 40)
        }else{
            return CGSize(width: cvTabDetails.frame.width, height: cvTabDetails.frame.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for first  cell
        if collectionView.isEqual(cvTabBar){
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartTabBarCell", for: indexPath) as! CartTabBarCell
            
            cell.lblTitle.text = tabItemList[indexPath.row]
            
            if indexPath.elementsEqual(selectedIndxPath){
                cell.lblTitle.textColor = ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_COLOR)
                cell.uivIndicator.isHidden = false
            }else{
                cell.lblTitle.textColor = ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.COLOR_TAB_TEXT)
                cell.uivIndicator.isHidden = true
            }
            
            return cell
        }else{
            if indexPath.row == 0{
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartAddTabDetailsCell", for: indexPath) as! CartAddTabDetailsCell
                
                if let basketItems = basketData?.items {
                    cell.addcartItemList = basketItems
                    cell.delegate = self
                }
                
                return cell
                
            }else if indexPath.row == 1{
                
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartCustomOrderTabDetailsCell", for: indexPath) as! CartCustomOrderTabDetailsCell
                
                cell.customOrderCartItemList = customOrderCartItemList
                
                return cell
                
            }else if indexPath.row == 2{
                
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartTrackingOrderTabDetailsCell", for: indexPath) as! CartTrackingOrderTabDetailsCell
                cell.delegate = self
                cell.trackingCartItemList = trackingCartItemList
                return cell
                
            }else{
                
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartDeliveryCompleteTabDetailsCell", for: indexPath) as! CartDeliveryCompleteTabDetailsCell
                
                cell.deliveryCompleteCartItemList = deliveryCompleteCartItemList
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(cvTabBar){
            selectedIndxPath = indexPath
//            cvTabBar.reloadData()
            
            cvTabDetails.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }else{
            
        }
    }
    
}

//
extension CartViewController: CartTrackingOrderTabDetailsCellDelegate{
    func onTapTrackingCartItem() {
        let vc = UIStoryboard.init(name: "Driver", bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailsViewController") as! DeliveryDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CartViewController: StoreSubscriber {
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
    }
}

extension CartViewController: CartAddTabDetailsCellDelegate {

    func increase(basketId: Int) {
        let url = "\(ApiEndpoints.URI_PUT_INCREASE_CART)/\(basketId)"
        self.ChangeCountBasket(url: url)
    }

    func decrease(basketId: Int) {
        let url = "\(ApiEndpoints.URI_PUT_DECREASE_CART)/\(basketId)"
        self.ChangeCountBasket(url: url)
    }

    func delete(basketId: Int) {
        let url = "\(ApiEndpoints.URI_DELETE_CART)/\(basketId)"
        self.PlateDeleteFromBasket(url: url)
    }
}
