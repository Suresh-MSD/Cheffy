//
//  ItemCartDetailsViewController.swift
//  chef
//
//  Created by Eddie Ha on 20/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import MapKit

class CheckoutViewController: BaseViewController {

    var environment:String = PayPalEnvironmentNoNetwork {

        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    //MARK: Properties
    public let CLASS_NAME = CheckoutViewController.self.description()
    private var userShippingAddress = UserShippingAddress()
    
    public var cartItemData: BasketModel?
    
    private var cartItemList = [BasketItem]()
    
    private var cardData: NSMutableDictionary?
    private var SelectedCardPayment: UserCardDetail?
    
    private let userProfileService = UserProfileService.getInstance()
    
    //MARK: Outlets
    @IBOutlet weak var svchekoutItemCartDetails: UIScrollView!
    @IBOutlet weak var cvCartItemList: UICollectionView!
    @IBOutlet weak var consCartItemlistHeight: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblUserShippingaddess: UILabel!
    @IBOutlet weak var btnDelivery: UIButton!
    @IBOutlet weak var btnPickupOrder: UIButton!
    @IBOutlet weak var tfPromoCode: UITextField!
    @IBOutlet weak var btnApplyPromoCode: UIButton!
    @IBOutlet weak var uivCalculationBox: UIView!
    @IBOutlet weak var uivPaymentCreditCard: UIView!
    @IBOutlet weak var uivPaymentCash: UIView!
    @IBOutlet weak var uivPaymentPaypal: UIView!
    @IBOutlet weak var lblPaymentCreditcard: UILabel!
    @IBOutlet weak var lblPaymentCash: UILabel!
    @IBOutlet weak var lblPaymentPaypal: UILabel!
    @IBOutlet weak var btnCheckout: UIButton!
    
    
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblDeliveryFees: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    var payPalConfig = PayPalConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        setBasketData()
        
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Awesome Shirts, Inc."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    //MARK: Actions
    //when tap on Add Item
    @IBAction func AddItemButton(_ sender: UIButton) {
        
        self.tabBarController?.selectedIndex = 0
      
    }
    
    
    //MARK: Actions
    //when tap on back button
    @IBAction func onTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true )
    }

    //when tap on onTapDeliveryButton
    @IBAction func onTapDeliveryButton(_ sender: UIButton) {
        
//        if
        btnDelivery.backgroundColor = UIColor.red
        btnDelivery.setTitleColor(UIColor.white, for: .normal)
        btnPickupOrder.backgroundColor = UIColor.white
        btnPickupOrder.setTitleColor(#colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1), for: .normal)
        
        
    }

    //when tap on PickupOrderButton
    @IBAction func onTapPickupOrderButton(_ sender: UIButton) {
        btnDelivery.backgroundColor = UIColor.white
        btnDelivery.setTitleColor(#colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1), for: .normal)
        btnPickupOrder.backgroundColor = UIColor.red
        btnPickupOrder.setTitleColor(UIColor.white, for: .normal)
    }
    
    //when tap on payment credit card
    @IBAction func onTapPaymentCreditCard(_ sender: UITapGestureRecognizer) {
        print("\(CLASS_NAME)-- onTapPaymentCreditCard()")
        
        deselectPaymentMethod(parentView: uivPaymentPaypal, titleView: lblPaymentPaypal)
        deselectPaymentMethod(parentView: uivPaymentCash, titleView: lblPaymentCash)
        selectPaymentMethod(parentView: uivPaymentCreditCard, titleView: lblPaymentCreditcard)
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserCardListVC") as! UserCardListVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //when tap on payment cash
    @IBAction func onTapPaymentCash(_ sender: UITapGestureRecognizer) {
        deselectPaymentMethod(parentView: uivPaymentPaypal, titleView: lblPaymentPaypal)
        deselectPaymentMethod(parentView: uivPaymentCreditCard, titleView: lblPaymentCreditcard)
        selectPaymentMethod(parentView: uivPaymentCash, titleView: lblPaymentCash)
    }
    
    //when tap on payment paypal
    @IBAction func onTapPaymentPaypal(_ sender: UITapGestureRecognizer) {
        deselectPaymentMethod(parentView: uivPaymentCash, titleView: lblPaymentCash)
        deselectPaymentMethod(parentView: uivPaymentCreditCard, titleView: lblPaymentCreditcard)
         selectPaymentMethod(parentView: uivPaymentPaypal, titleView: lblPaymentPaypal)
        
        let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        let shipping = NSDecimalNumber(string: "5.99")
        let tax = NSDecimalNumber(string: "2.50")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Hipster Clothing", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
          let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
          present(paymentViewController!, animated: true, completion: nil)
        }
    }
    
    //when tap on checkout button
    @IBAction func onTapCheckoutButton(_ sender: UIButton) {
        // TODO: API integration
        
        guard let _ = self.SelectedCardPayment else {
            showMessageWith("", "Please select Payment method", .warning)
            return
        }
        
        if isConnectedToNetwork() {
            
            ProgressViewHelper.show(type: .full)
            CheckOutReuest(deliveryType: "user").exec { [weak self]
                (result, error) in
                ProgressViewHelper.hide()
                if let strongSelf = self {
                    if let message = result?.message {
                        
                        if message == "User have no default card saved. Please send card information" {
                            
                            strongSelf.showMessageWith("User have no default card saved. Please send card information", message, .error)
                        } else {
                            
                            strongSelf.showMessageWith("", message, .success)
                            strongSelf.navigationController?.popToRootViewController(animated: true)
                            strongSelf.tabBarController?.selectedIndex = 0
                        }
                    } else {
                        strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                    }
                }
            }
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }
    }
    
    
    //MARK: Instance Method
    //initialize
    private func initialize() -> Void{
        //shadows of buttons
        btnCheckout.elevate(elevation: 10, cornerRadius: 0, color: UIColor.red)
        btnDelivery.elevate(elevation: 6, cornerRadius: 10, color:ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_GRAY_COLOR, alpha: 0.5))
        btnPickupOrder.elevate(elevation: 6, cornerRadius: 10, color:ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_GRAY_COLOR, alpha: 0.5))
        tfPromoCode.elevate(elevation: 6, cornerRadius: 10, color:ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_GRAY_COLOR, alpha: 0.5))
        uivCalculationBox.elevate(elevation: 10, cornerRadius: 10, color:ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_GRAY_COLOR, alpha: 0.5))
         uivPaymentCreditCard.elevate(elevation: 10, cornerRadius: 10, color:ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_COLOR, alpha: 0.2))
         uivPaymentPaypal.elevate(elevation: 10, cornerRadius: 10, color:ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_COLOR, alpha: 0.2))
         uivPaymentCash.elevate(elevation: 10, cornerRadius: 10, color:ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_COLOR, alpha: 0.2))
        
        
       //selected  payment method
        uivPaymentCreditCard.backgroundColor = ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_COLOR, alpha: 1.0)
        lblPaymentCreditcard.textColor = UIColor.white
        
        
        //init collectionviews
        cvCartItemList.delegate = self
        cvCartItemList.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        //        layout.itemSize = CGSize(width: (cvTabBar.frame.width/2)-15, height: (cvTabBar.frame.width/2)-15)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        cvCartItemList.collectionViewLayout = layout
        
        //Register cell
        cvCartItemList?.register(UINib(nibName: "CartAddInnerCell", bundle: nil), forCellWithReuseIdentifier: "CartAddInnerCell")
    }
    
    //select payment method
    private func selectPaymentMethod(parentView:UIView, titleView:UILabel) -> Void {
        parentView.backgroundColor = ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_COLOR, alpha: 1.0)
        titleView.textColor = UIColor.white

    }
    
    //select payment method
    private func deselectPaymentMethod(parentView:UIView, titleView:UILabel) -> Void {
        parentView.backgroundColor = UIColor.white
        titleView.textColor = ColorGenerator.UIColorFromHex(rgbValue: ColorCollection.APP_THEME_GRAY_COLOR, alpha: 1.0)
        
    }
    
    //show user location
    private func showUserLocation() -> Void {
        self.lblUserShippingaddess.text = "\(self.userShippingAddress.zipCode ?? ""), \(self.userShippingAddress.addressLine1 ?? ""), \(self.userShippingAddress.addressLine2 ?? ""), \(self.userShippingAddress.city ?? ""), \(self.userShippingAddress.state ?? "")"
        let center = CLLocationCoordinate2D(latitude: Double(self.userShippingAddress.lattitude ?? "0") as! CLLocationDegrees, longitude: Double(self.userShippingAddress.longitude ?? "0") as! CLLocationDegrees)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(self.userShippingAddress.lattitude ?? "0") as! CLLocationDegrees, Double(self.userShippingAddress.longitude ?? "0") as! CLLocationDegrees)
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = ""
        self.mapView.addAnnotation(objectAnnotation)
        self.mapView.setRegion(region, animated: true)
    }

    private func setBasketData() {
        if let basket = cartItemData, let basketItems = cartItemData?.items {
            self.cartItemList = basketItems
            self.lblSubtotal.text = "$\(basket.subTotal ?? 0)"
            self.lblDeliveryFees.text = "$\(basket.deliveryFee ?? 0)"
            self.lblTotal.text = "$\(basket.total ?? 0)"
            self.cvCartItemList.reloadData()
        }
    }
    
}


//MARK: Extension
//MARK: API CALL
extension CheckoutViewController {
    

    func getBasketData() {
        
        ProgressViewHelper.show(type: .full)
        BasketRequest().exec { [weak self]
            (result, error) in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                if result?.items?.count ?? 0 == 0 {
                    self?.navigationController?.popViewController(animated: true)
                }
                if let basket = result, let basketItems = result?.items {

                    strongSelf.cartItemData = basket
                    strongSelf.cartItemList = basketItems
                    strongSelf.lblSubtotal.text = "$\(basket.subTotal ?? 0)"
                    strongSelf.lblDeliveryFees.text = "$\(basket.deliveryFee ?? 0)"
                    strongSelf.lblTotal.text = "$\(basket.total ?? 0)"
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        }
    }

    func changeCountBasket(url: String) {

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

    func deleteBasketRequest(url: String) {

        ProgressViewHelper.show(type: .full)
        CartService.getInstance().deleteBasketRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                print("\(strongSelf.CLASS_NAME) -- deleteBasketRequest() -- url = \(url),  response = \(response)")
                if response.result.isSuccess {
                    DispatchQueue.main.async {
                        strongSelf.getBasketData()
                    }
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
}


//MARK: CollectionView
extension CheckoutViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let totalItem = cartItemList.count
        consCartItemlistHeight.constant = CGFloat(totalItem*130)
        
        svchekoutItemCartDetails.contentSize = CGSize(width: svchekoutItemCartDetails.contentSize.width, height: consCartItemlistHeight.constant+20)
        
        return totalItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for tab bar cell
        return CGSize(width: cvCartItemList.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for first  cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartAddInnerCell", for: indexPath) as! CartAddInnerCell
        
        cell.uivContainer.elevate(elevation: 15, cornerRadius: 0, color : ColorGenerator.UIColorFromHex(rgbValue: 0x000000, alpha: 0.3))
        
        let cartItem = cartItemList[indexPath.row]
        cell.configureBasketCell(basket: cartItem, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //get all new plate by pagination list
    private func PostCardDetails( details : NSMutableDictionary)  {
        
        ProgressViewHelper.show(type: .full)
        let url = ApiEndpoints.URI_POST_CARD_DETAILS
        let param: [String : Any] = [ "number" : details["number"] ?? "",
                                      "exp_month" : details["exp_month"] ?? 0,
                                      "exp_year" : details["exp_year"] ?? 0,
                                      "cvc" : details["cvc"] ?? 0
                                    ]
        
        AddCardDetailsService.getInstance().addCardRequest(url: url, parameters:param, completionHandler: { [weak self] response in
            
            ProgressViewHelper.hide()
            
            if let strongSelf = self {
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    print(json)
                    strongSelf.cardData = details
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
}

extension CheckoutViewController: SelectPaymentCart {
    
    func getPaymentData(card: UserCardDetail) {
        
        if !Helper.isLoggedIn() {
            
            SnackbarCollection.showSnackbarWithText(text: "Login for add Card.")
            return
        }
        
        self.SelectedCardPayment = card
        self.lblPaymentCreditcard.text = "\((card.card?.funding ?? "").capitalizingFirstLetter()) card - **** \(card.card?.last4 ?? "")"
    }
    
}

extension CheckoutViewController: CartAddInnerCellDelegate {

    func increaseItem(at: IndexPath) {
        let cartItem = cartItemList[at.row]
        guard let id = cartItem.basketItemId else {
            return
        }
        let url = "\(ApiEndpoints.URI_PUT_INCREASE_CART)/\(id)"
        changeCountBasket(url: url)
    }

    func decreaseItem(at: IndexPath) {
        let cartItem = cartItemList[at.row]
        guard let id = cartItem.basketItemId else {
            return
        }
        let url = "\(ApiEndpoints.URI_PUT_DECREASE_CART)/\(id)"
        changeCountBasket(url: url)
    }

    func delete(at: IndexPath) {
        let cartItem = cartItemList[at.row]
        guard let id = cartItem.basketItemId else {
            return
        }
        let url = "\(ApiEndpoints.URI_DELETE_CART)/\(id)"
        deleteBasketRequest(url: url)
    }
}

extension CheckoutViewController : PayPalPaymentDelegate {
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
      print("PayPal Payment Cancelled")
      paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
      print("PayPal Payment Success !")
      paymentViewController.dismiss(animated: true, completion: { () -> Void in
        // send completed confirmaion to your server
        print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
        
      })
    }
    
    
}
