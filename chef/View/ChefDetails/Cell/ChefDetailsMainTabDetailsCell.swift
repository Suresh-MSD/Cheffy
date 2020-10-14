//
//  ChefDetailsTopTabDetailsCell.swift
//  chef
//
//  Created by Eddie Ha on 25/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ChefDetailsMainTabDetailsCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = ChefDetailsMainTabDetailsCell.self.description()
    open var delegate:ChefDetailsNestedTabDetailsCellDelegate!
    open var plate = Plate(){
        didSet{
            self.cvTabDetails.reloadData()
            self.lblTitle.text = self.plate.name
            self.lblTimeline.text = "\(self.plate.deliveryTime ?? 0)"
            self.lblPrice.text = "$\(self.plate.price ?? 0)"
        }
    }
    
    
    //MARK: Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTimeline: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnTabDetails: UIButton!
    @IBOutlet weak var btnTabReview: UIButton!
    @IBOutlet weak var uivTabIndicator: UIView!
    @IBOutlet weak var cvTabDetails: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialization()
    }

    //MARK: Actions
    //when click on tab details
    @IBAction func onClickTabDetails(_ sender: UIButton) {
        cvTabDetails.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        selectTab(tab: sender)
    }
    
    //when click on tab
    @IBAction func onClickTabReview(_ sender: UIButton) {
        cvTabDetails.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        selectTab(tab: sender)
    }
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvTabDetails.delegate = self
        cvTabDetails.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cvTabDetails.frame.width, height: 300)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        cvTabDetails.collectionViewLayout = layout
        
        //Register cells
        cvTabDetails?.register(UINib(nibName: "ChefDetailsNestedTabDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ChefDetailsNestedTabDetailsCell")
        cvTabDetails?.register(UINib(nibName: "ChefDetailsNestedTabReviewCell", bundle: nil), forCellWithReuseIdentifier: "ChefDetailsNestedTabReviewCell")
    }
    
    //select tab
    private func selectTab(tab:UIButton) -> Void {
        btnTabDetails.setTitleColor(UIColor.darkGray, for: .normal)
        btnTabReview.setTitleColor(UIColor.darkGray, for: .normal)
        
        tab.setTitleColor(UIColor.red, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.uivTabIndicator.frame = CGRect(x: tab.frame.origin.x, y: self.uivTabIndicator.frame.origin.y, width: self.uivTabIndicator.frame.width, height: self.uivTabIndicator.frame.height)
            
        })
    }
}

//MARK: Extension
//MARK: CollectionView
extension ChefDetailsMainTabDetailsCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let slide = round(scrollView.contentOffset.x/cvTabDetails.frame.width)
        
        //change tab
        if slide == 0 {
            selectTab(tab: btnTabDetails)
        }else if slide == 1 {
            selectTab(tab: btnTabReview)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0{
            return CGSize(width: cvTabDetails.frame.width, height: 275)
        }else{
            return CGSize(width: cvTabDetails.frame.width, height: 275)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ChefDetailsNestedTabDetailsCell", for: indexPath) as! ChefDetailsNestedTabDetailsCell
            
            if delegate != nil {
                cell.delegate = delegate
            }
            
            cell.plate = plate 
            
            return cell
        }else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ChefDetailsNestedTabReviewCell", for: indexPath) as! ChefDetailsNestedTabReviewCell
            
            cell.plate = plate 
            
            return cell
        }
        
    }
    
}


