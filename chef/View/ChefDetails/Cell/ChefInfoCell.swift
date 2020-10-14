//
//  ImageSliderCell.swift
//  chef
//
//  Created by Eddie Ha on 23/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

//MARK: Protocols
protocol ChefInfoCellDelegate:NSObjectProtocol {
    func onClickBackButton() -> Void
}

class ChefInfoCell: UICollectionViewCell {
    
    //MARK: Properties
    public let  CLASS_NAME = ChefInfoCell.self.description()
    open var delegate:ChefInfoCellDelegate!
    public var imageList = [UIImage]()
    public var slideTimer:Timer!
    public var slideCounter = 0
    open var plateImages = [PlateImage](){
        didSet{
            self.cvImageSlider.reloadData()
        }
    }
    
    open var kitchenImages = [KitchenImage](){
        didSet{
            self.cvImageSlider.reloadData()
        }
    }
    
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var cvImageSlider: UICollectionView!
    @IBOutlet weak var pcImageCounter: UIPageControl!
    @IBOutlet weak var uivProfilePictureContainer: UIView!
    @IBOutlet weak var ivProfilePicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblTimeline: UILabel!
    @IBOutlet weak var lblActionType: UILabel!
    @IBOutlet weak var lblLabel: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialization()
//        getImages()
        pcImageCounter.numberOfPages = plateImages.count
        pcImageCounter.hidesForSinglePage = true
        pcImageCounter.currentPage = 0
        
        slideTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeImageSlider(_ : )), userInfo: nil, repeats: true)
        cvImageSlider.reloadData()
        
        
    }
    
    //MARK: Actions
    @IBAction func onClickBackButton(_ sender: UIButton) {
        if delegate != nil{
            delegate.onClickBackButton()
        }
    }
    

    //get images
    public func getImages() -> Void{
        imageList.append(UIImage(named: "img_food_one")!)
        imageList.append(UIImage(named: "img_food_two")!)
        imageList.append(UIImage(named: "img_food_three")!)
        imageList.append(UIImage(named: "img_food_four")!)
        imageList.append(UIImage(named: "img_food_one")!)
        imageList.append(UIImage(named: "img_food_two")!)
    }
    
    //MARK: Intsance Method
    //initialization
    public func initialization() -> Void {
        
        //init collectionviews
        cvImageSlider.delegate = self
        cvImageSlider.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cvImageSlider.frame.width, height: 300)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        cvImageSlider.collectionViewLayout = layout
        
        //cell for food list collection view
        let nibForImageSliderCell = UINib(nibName: "ImageSliderCell", bundle: nil)
        cvImageSlider?.register(nibForImageSliderCell, forCellWithReuseIdentifier: "ImageSliderCell")
        
        self.ivProfilePicture.setImageFromUrl(url: "adsdas")
    }
    
    //change image slider
    @objc public func changeImageSlider(_ sender:Timer) -> Void {
        if slideCounter < plateImages.count{
            cvImageSlider.scrollToItem(at: IndexPath(item: slideCounter, section: 0), at: .centeredHorizontally, animated: true)
            pcImageCounter.currentPage = slideCounter
            slideCounter = slideCounter + 1
        }else{
            slideCounter = 0
            cvImageSlider.scrollToItem(at: IndexPath(item: slideCounter, section: 0), at: .centeredHorizontally, animated: true)
            pcImageCounter.currentPage = slideCounter
        }
    }
}


//MARK: Extension
//MARK: CollectionView
extension ChefInfoCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let slide = round(scrollView.contentOffset.x/cvImageSlider.frame.width)
        pcImageCounter.currentPage = Int(slide)
        slideCounter = Int(slide)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        pcImageCounter.numberOfPages = plateImages.count
        
        return plateImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvImageSlider.frame.width, height: cvImageSlider.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSliderCell", for: indexPath) as! ImageSliderCell
        
//        let image = kitchenImages[indexPath.row].url ?? ""
        let imageUrl = plateImages[indexPath.row].url ?? ""
        cell.ivSliderImage.setImageFromUrl(url: imageUrl)
        Helper.maskView(cell.contentView, topLeftRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25, topRightRadius: 0, width: cvImageSlider.frame.width, height: cvImageSlider.frame.height)
        
        return cell
        
    }
    
}
