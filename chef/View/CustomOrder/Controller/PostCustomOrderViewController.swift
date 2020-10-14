//
//  PostCustomOrderViewController.swift
//  chef
//
//  Created by Eddie Ha on 11/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Pickle
import Photos
import Cloudinary
import SVProgressHUD
import SwiftyJSON

class PostCustomOrderViewController: BaseViewController {

    //MARK: Properties
    public let CLASS_NAME = PostCustomOrderViewController.self.description()
    private var picker:ImagePickerController!
    private var orderImageList = [PHAsset]()
    private var orderImageDatalist = [Data]()
    private var orderImageUrllist = [NSMutableDictionary]()
    private var chefDistance:Float = 0.0
    private var closeDate = Date()
    
    //MARK: Outlets
    @IBOutlet weak var tfPlateName: UITextField!
    @IBOutlet weak var tvPlateDescription: UITextView!
    @IBOutlet weak var cvOrderImageList: UICollectionView!
    @IBOutlet weak var btnUploadImage: UIButton!
    @IBOutlet weak var slDistanceRange: UISlider!
    @IBOutlet weak var btnReservationRightNow: UIButton!
    @IBOutlet weak var btnReservationFuture: UIButton!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var btnCustomOrder: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialization
        initialization()
    }

    //MARK: Actions
    //when tap on back button
    @IBAction func onTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //when tap on upload images
    @IBAction func onTapUploadImagesButton(_ sender: UIButton) {
        let  source = UIImagePickerController()
        source.sourceType = .photoLibrary
        picker = ImagePickerController(
            selectedAssets: orderImageList,
            configuration: Pickle.Parameters(),
            cameraType: UIImagePickerController.self
        )
        picker.delegate = self as? ImagePickerControllerDelegate
        present(picker, animated: true, completion: nil)
    }
    
    //on tap reservatio right now button
    @IBAction func onTapreservationRightNow(_ sender: UIButton) {
        btnReservationFuture.setTitle("\(Date())", for: .normal)
    }
    
    //on tap reservation future
    @IBAction func onTapReservationFuture(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrderReservationViewController") as! OrderReservationViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //when tap on post order
    @IBAction func onTapPostOrder(_ sender: UIButton) {
        let plateName = tfPlateName.text!
        let plateDescription = tvPlateDescription.text!

        guard
            let tfQuantityText = tfQuantity.text else {
                self.showMessageWith("", "Please enter the correct number", .warning)
                return
        }

        guard let quantity = Int(tfQuantityText) else {
                self.showMessageWith("", "Please enter quantity", .warning)
            return
        }
        
        if orderImageList.count < 1{
            self.showMessageWith("", "Please add food image", .warning)
            return
        } else if plateName.elementsEqual(""){
            self.showMessageWith("", "Please enter food name", .warning)
            return
        } else if plateDescription.elementsEqual(""){
            self.showMessageWith("", "Please enter food description", .warning)
            return
        } else{
        
            // TODO: set dynamic values

            // No Available Patameters for those parameter
            //let letchefDistance = slDistanceRange.value
            //let time = btnReservationFuture.titleLabel
            for imageData in orderImageDatalist{
                uploadImageToCloudinary(imageData: imageData)
            }
            
            // TODO: Check API
            // for min and max price there is no interface ui exist for it.
            
            if isConnectedToNetwork() {
                ProgressViewHelper.show(type: .full)
                CreateCustomPlateRequest(name: plateName, description: plateDescription, minPrice: 10, maxPrice: 30, quantity: quantity, images: orderImageUrllist, closeDate: closeDate).exec {   [weak self]
                    (result, error) in
                    ProgressViewHelper.hide()
                    if let strongSelf = self {
                        if let successMessage = result?.message {
                            strongSelf.showMessageWith("Success", successMessage, .success)
                            strongSelf.navigationController?.popViewController(animated: true)
                        } else {
                            strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                        }
                    }
                }
            } else {
                showMessageWith(AlertKey, No_Internet_Connection, .error)
            }
        }
    }
    
    
    //MARK: Instance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvOrderImageList.delegate = self
        cvOrderImageList.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: cvOrderImageList.frame.width/3, height: cvOrderImageList.frame.height/2)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .vertical
        cvOrderImageList.collectionViewLayout = layout
        
        //cell for food list collection view
        cvOrderImageList?.register(UINib(nibName: "PostOrderImageCell", bundle: nil), forCellWithReuseIdentifier: "PostOrderImageCell")
        
        //style buttons
         btnCustomOrder.elevate(elevation: 10, cornerRadius: 0, color: UIColor.red)
        
    }
}


//MARK: Extension
//MARK: Network Call
extension PostCustomOrderViewController{
    private func uploadImageToCloudinary(imageData: Data) -> Void {
//        let config = CLDConfiguration(cloudName: "dimkdqhsw", secure: true)
//        let cloudinary = CLDCloudinary(configuration: config)
        let config = CLDConfiguration(cloudinaryUrl: "cloudinary://322541948387762:_LQvfzoV7RjgyaNtX_KQ5SKAhco@dimkdqhsw")
        let cloudinary = CLDCloudinary(configuration: config!)
        let imageName = "order_image_\(Date().timeIntervalSince1970).jpeg"
        let url = cloudinary.createUrl().generate(imageName)
        
        let imageOjc = NSMutableDictionary()
        imageOjc.setValue(imageName, forKey: "name")
        imageOjc.setValue(url ?? "", forKey: "url")
        
        self.orderImageUrllist.append(imageOjc)
        
        cloudinary.createUploader().signedUpload(data: imageData).progress({
            progress in
            
            print("\(self.CLASS_NAME) -- uploadImageToCloudinary() -- progress = \(progress.fractionCompleted)")
        })
    }
}


//MARK: CollectionView
extension PostCustomOrderViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (cvOrderImageList.frame.width/3)-3, height: (cvOrderImageList.frame.height/2)-2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "PostOrderImageCell", for: indexPath) as! PostOrderImageCell
//        cell.ivOrderImage.image = UIImage(named: imageList[indexPath.row].burstIdentifier!)
        getImageFromAsset(asset: orderImageList[indexPath.row], imageView: cell.ivOrderImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}


//ImagePickerControllerDelegate
extension PostCustomOrderViewController: ImagePickerControllerDelegate{
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishLaunchingCameraWith assets: [PHAsset]) {
        
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        self.orderImageList = assets
        self.orderImageDatalist = [Data]()
        self.cvOrderImageList.reloadData()
        
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: ImagePickerController, didSelectImageAsset asset: PHAsset) {
        
    }
    
    func imagePickerController(_ picker: ImagePickerController, didDeselectImageAsset asset: PHAsset) {
        
    }

    private func getImageFromAsset(asset:PHAsset, imageView:UIImageView) -> Void{
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.fast
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: imageView.frame.size, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (currentImage, info) in
            imageView.image = currentImage
            self.orderImageDatalist.append((currentImage?.jpegData(compressionQuality: 0.6))!)
//            callback(currentImage!)
        })
    }
}

//OrderReservationDelegate
extension PostCustomOrderViewController: OrderReservationDelegate {

    func setDate(selectDate: Date, fromTime: String?, toTime: String?, isAllDay: Bool) {

        self.closeDate = selectDate
        let calendar = Calendar.current
        let monthText = selectDate.monthAsString()
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = calendar.timeZone
        if
            let from = fromTime,
            let to = toTime {

            //e.g  August 20, 6am~6pm
            formatter.dateFormat = " dd, "
            let btnReservationText = monthText + formatter.string(from: selectDate) + from + "~" + to
            print(btnReservationText)
            btnReservationFuture.setTitle("\(btnReservationText)", for: .normal)
        } else {
            //e.g  August 20, 20:00
            formatter.dateFormat = "dd, HH:mm"
            let btnReservationText = monthText + " " + formatter.string(from: selectDate)
            print(btnReservationText)
            btnReservationFuture.setTitle("\(btnReservationText)", for: .normal)
        }
    }
}
