    //
//  ChefDetailsMainTabCell.swift
//  chef
//
//  Created by Eddie Ha on 25/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ChefDetailsMainTabCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = ChefDetailsMainTabCell.self.description()
    open var delegate: ChefDetailsNestedTabDetailsCellDelegate!
    open var plate = Plate(){
        didSet{
            self.cvTabDetails.reloadData()
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var uivContainer: UIView!
    @IBOutlet weak var btnTabPlate: UIButton!
    @IBOutlet weak var btnTabKitchen: UIButton!
    @IBOutlet weak var btnReceipts: UIButton!
    @IBOutlet weak var uivTabIndicator: UIView!
    @IBOutlet weak var cvTabDetails: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialization()
    }
    

   //MARK: Actions
    //when click on the plate tab bar section
    @IBAction func onClickTabThePlate(_ sender: UIButton) {
        cvTabDetails.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        selectTab(tab: sender)
    }
    
    //when click on  tab kitchen
    @IBAction func onClickTabKitchen(_ sender: UIButton) {
        cvTabDetails.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        selectTab(tab: sender)
    }
    
    
    //when click on tab Receipts
    @IBAction func onClicktabReceipts(_ sender: UIButton) {
        cvTabDetails.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
        selectTab(tab: sender)
    }
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvTabDetails.delegate = self
        cvTabDetails.dataSource = self
//        cvTabDetails.panGestureRecognizer.delegate = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cvTabDetails.frame.width, height: 400)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        cvTabDetails.collectionViewLayout = layout
        
        //cell for ChefDetailsMainTabDetailsCell
        let nibChefDetailsMainTabDetailsCell = UINib(nibName: "ChefDetailsMainTabDetailsCell", bundle: nil)
        cvTabDetails?.register(nibChefDetailsMainTabDetailsCell, forCellWithReuseIdentifier: "ChefDetailsMainTabDetailsCell")
    }
    
    //select tab
    private func selectTab(tab:UIButton) -> Void {
        btnTabPlate.setTitleColor(UIColor.darkGray, for: .normal)
        btnTabKitchen.setTitleColor(UIColor.darkGray, for: .normal)
        btnReceipts.setTitleColor(UIColor.darkGray, for: .normal)
        
        tab.setTitleColor(UIColor.red, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.uivTabIndicator.frame = CGRect(x: tab.frame.origin.x, y: self.uivTabIndicator.frame.origin.y, width: self.uivTabIndicator.frame.width, height: self.uivTabIndicator.frame.height)
            
        })
    }
}


//MARK: Extension
//MARK: Gesture Delegate
//extension ChefDetailsMainTabCell : UIGestureRecognizerDelegate{
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        guard let view = gestureRecognizer.view, view.isKind(of: UIControl.self) else {
//            return true
//        }
//        return false
//    }
//}

//MARK: CollectionView
extension ChefDetailsMainTabCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let slide = round(scrollView.contentOffset.x/cvTabDetails.frame.width)
        
        //change tab
        if slide == 0 {
            selectTab(tab: btnTabPlate)
        }else if slide == 1 {
            selectTab(tab: btnTabKitchen)
        }else if slide == 2 {
            selectTab(tab: btnReceipts)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvTabDetails.frame.width, height: 375)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ChefDetailsMainTabDetailsCell", for: indexPath) as! ChefDetailsMainTabDetailsCell
        
        if delegate != nil {
            cell.delegate = delegate
        }
        
        cell.plate = plate
        
        return cell
        
    }
    
}
