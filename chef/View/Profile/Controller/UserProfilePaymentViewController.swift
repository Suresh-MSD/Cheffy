//
//  UserProfilerPaymentViewController.swift
//  chef
//
//  Created by Eddie Ha on 2/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SwiftyJSON


class UserProfilePaymentViewController: BaseViewController {
    
    //MARK: Properties
    public let CLASS_NAME = UserProfilePaymentViewController.self.description()
    private var imageList = [UIImage]()
    private var slideTimer:Timer!
    private var slideCounter = 0
    
    
    //MARK: Outlets
    @IBOutlet weak var svPaymentFormContainer: UIScrollView!
    @IBOutlet weak var cvCardList: UICollectionView!
    @IBOutlet weak var pcCardList: UIPageControl!
    @IBOutlet weak var uivSliderContainer: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var tfCardName: UITextField!
    
    @IBOutlet weak var tfCardNumSection1: UITextField!
    @IBOutlet weak var tfCardNumSection2: UITextField!
    @IBOutlet weak var tfCardNumSection3: UITextField!
    @IBOutlet weak var tfCardNumSection4: UITextField!
    
    @IBOutlet weak var tfExpireMonth: UITextField!
    @IBOutlet weak var tfExpireYear: UITextField!
    
    @IBOutlet weak var tfCVC: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initialize
        initialize()
        getImages()
        pcCardList.numberOfPages = imageList.count
        pcCardList.currentPage = 0
        slideTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeImageSlider(_ : )), userInfo: nil, repeats: true)
        cvCardList.reloadData()
    }

    
    //MARK: Actions
    //when click on back button
    @IBAction func onClickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Instance Metehod
    //initialize
    private func initialize() -> Void {
        uivSliderContainer.elevate(elevation: 6, cornerRadius: 0)
        
        //set content size of scroll view controller
        svPaymentFormContainer.isScrollEnabled = true
//        svPaymentFormContainer.contentSize = CGSize(width: self.view.frame.width, height: 1000)
        
        //init collectionviews
        cvCardList.delegate = self
        cvCardList.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 00, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cvCardList.frame.width, height: 230)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        cvCardList.collectionViewLayout = layout
//        cvCardList.elevate(elevation: 6, cornerRadius: 15)
//        Helper.maskView(uivSliderContainer, topLeftRadius: 15, bottomLeftRadius: 15, bottomRightRadius: 15, topRightRadius: 15, width: cvCardList.frame.width, height: cvCardList.frame.height)
        
        //cell for food list collection view
        cvCardList?.register(UINib(nibName: "ImageSliderCell", bundle: nil), forCellWithReuseIdentifier: "ImageSliderCell")
        
        
        tfCardName.delegate = self
        
        tfCardNumSection1.delegate = self
        tfCardNumSection2.delegate = self
        tfCardNumSection3.delegate = self
        tfCardNumSection4.delegate = self
        
        tfCardNumSection1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfCardNumSection2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfCardNumSection3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfCardNumSection4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        
        tfExpireMonth.delegate = self
        tfExpireYear.delegate = self
        
        tfCVC.delegate = self
        
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        
        if tfCardName.text == "" {
            showMessageWith("", "Please enter a valid name", .warning)
        } else if tfCardNumSection1.text?.count != 4 || tfCardNumSection2.text?.count != 4
                || tfCardNumSection3.text?.count != 4 || tfCardNumSection4.text?.count != 4 {
            showMessageWith("", "Please enter a valid card number", .warning)
        } else if tfExpireMonth.text?.count != 2 || tfExpireYear.text?.count != 4{
            showMessageWith("", "Please enter a valid expire date", .warning)
        } else if tfCVC.text!.count < 3 {
            showMessageWith("", "Please enter a valid CVC", .warning)
        } else {
            let cardNumber = tfCardNumSection1.text! + tfCardNumSection2.text! + tfCardNumSection3.text! + tfCardNumSection4.text!
            
            let cardData = NSMutableDictionary()
            cardData.setValue(cardNumber, forKey: "number")
            cardData.setValue(tfExpireMonth.text!, forKey: "exp_month")
            cardData.setValue(tfExpireYear.text!, forKey: "exp_year")
            cardData.setValue(tfCVC.text!, forKey: "cvc")
            
            self.PostCardDetails(details: cardData)
        }
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
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }
    
    //get images
    public func getImages() -> Void{
        imageList.append(UIImage(named: "img_food_one")!)

    }
    
    //change image slider
    @objc public func changeImageSlider(_ sender:Timer) -> Void {
        if slideCounter < imageList.count{
            cvCardList.scrollToItem(at: IndexPath(item: slideCounter, section: 0), at: .centeredHorizontally, animated: true)
            pcCardList.currentPage = slideCounter
            slideCounter = slideCounter + 1
        }else{
            slideCounter = 0
            cvCardList.scrollToItem(at: IndexPath(item: slideCounter, section: 0), at: .centeredHorizontally, animated: true)
            pcCardList.currentPage = slideCounter
        }
    }
    
}

extension UserProfilePaymentViewController : UITextFieldDelegate {
    
    //MARK:- ALL FUNCTIONS
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 4
        
        if textField == tfCardName{
            maxLength = 20
        } else if textField == tfExpireMonth {
            maxLength = 2
        } else {
            maxLength = 4
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        
        let text = textField.text
        
        print(text)

        if (text?.utf16.count ?? 0) == 0 {
            switch textField{
            case tfCardNumSection1:
                tfCardNumSection1.becomeFirstResponder()
            case tfCardNumSection2:
                tfCardNumSection1.becomeFirstResponder()
            case tfCardNumSection3:
                tfCardNumSection2.becomeFirstResponder()
            case tfCardNumSection4:
                tfCardNumSection3.becomeFirstResponder()
            default:
                break
            }
        }
        
        if (text?.utf16.count ?? 0) >= 4{
            
            switch textField{
            case tfCardNumSection1:
                tfCardNumSection2.becomeFirstResponder()
            case tfCardNumSection2:
                tfCardNumSection3.becomeFirstResponder()
            case tfCardNumSection3:
                tfCardNumSection4.becomeFirstResponder()
            case tfCardNumSection4:
                tfCardNumSection4.resignFirstResponder()
            default:
                break
            }
        }else{

        }
    }
}

//MARK: Extension
//MARK: CollectionView
extension UserProfilePaymentViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let slide = round(scrollView.contentOffset.x/cvCardList.frame.width)
        pcCardList.currentPage = Int(slide)
        slideCounter = Int(slide)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvCardList.frame.width, height: cvCardList.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSliderCell", for: indexPath) as! ImageSliderCell
        
        let image = imageList[indexPath.row]
        cell.ivSliderImage.image = image
        Helper.maskView(cell, topLeftRadius: 15, bottomLeftRadius: 15, bottomRightRadius: 15, topRightRadius: 15, width: cell.frame.width, height: cell.frame.height)
        return cell
        
    }
    
}
