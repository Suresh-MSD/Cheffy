//
//  ReceiptDetailsViewController.swift
//  chef
//
//  Created by Eddie Ha on 30/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ReceiptDetailsViewController: UIViewController {
    
    //MARK: Properties
    public let CLASS_NAME = ReceiptDetailsViewController.self.description()
    open var plate = Plate(){
        didSet{
            self.cvReceiptsDetails?.reloadData()
        }
    }
    
    
    //MARK: Outlets
    @IBOutlet weak var cvReceiptsDetails: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialization()
    }

    //MARK: Actions
    //when click on back butto
    @IBAction func onClickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Intsance Method
    //initialization
    private func initialization() -> Void {
        
        //init collectionviews
        cvReceiptsDetails.delegate = self
        cvReceiptsDetails.dataSource = self
        
        //set collection view cell item cell
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cvReceiptsDetails.frame.width, height: 500)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        cvReceiptsDetails.collectionViewLayout = layout
//        cvChefDetailsInfo.contentInset.top = -UIApplication.shared.statusBarFrame.height
        
        //register cells
        cvReceiptsDetails?.register(UINib(nibName: "ReceiptHeaderCell", bundle: nil), forCellWithReuseIdentifier: "ReceiptHeaderCell")
        cvReceiptsDetails?.register(UINib(nibName: "ReceiptItemCell", bundle: nil), forCellWithReuseIdentifier: "ReceiptItemCell")
        cvReceiptsDetails?.register(UINib(nibName: "ReceiptImageCell", bundle: nil), forCellWithReuseIdentifier: "ReceiptImageCell")
    }
    
}


//MARK: Extension
//MARK: CollectionView
extension ReceiptDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (plate.ingredientList?.count ?? 0) + (plate.receiptImageList?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for header cell
        if indexPath.row == 0{
            return CGSize(width: cvReceiptsDetails.frame.width, height: 50)
        }
           
            //if receipt item cell
        else if (indexPath.row) <= ((plate.ingredientList?.count ?? 0)){
            return CGSize(width: cvReceiptsDetails.frame.width, height: 30)
        }
            //if receiot image cell
        else {
             return CGSize(width: cvReceiptsDetails.frame.width, height: 450)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //for header cell
        if indexPath.row == 0{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiptHeaderCell", for: indexPath) as! ReceiptHeaderCell
            
            return cell
        }
            
            //for receipt items  cell
        else if (indexPath.row) <= ((plate.ingredientList?.count ?? 0)){
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiptItemCell", for: indexPath) as! ReceiptItemCell
            
            populateReceiptItemCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
         
            //for receipt image cell
        else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiptImageCell", for: indexPath) as! ReceiptImageCell
            
            populateReceiptImageCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
        
    }
    
    //populet receipt item cell
    private func populateReceiptItemCell(cell: ReceiptItemCell, indexPath: IndexPath) -> ReceiptItemCell {
        
        cell.lblReceiptItem.text = plate.ingredientList?[indexPath.row-1].name
        cell.lblItemDate.text = plate.ingredientList?[indexPath.row-1].purchase_date
        
        return cell
    }
    
    //populet recipt image cell
    private func populateReceiptImageCell(cell: ReceiptImageCell, indexPath: IndexPath) -> ReceiptImageCell {
        
        cell.lblReceiptTitle.text = plate.receiptImageList?[indexPath.row - 1 -  (plate.ingredientList?.count ?? 0)].name
        
        if let imageUrl = plate.receiptImageList?[indexPath.row - 1 - (plate.ingredientList?.count ?? 0)].url{
            cell.ivReceiptImage.setImageFromUrl(url: imageUrl)
        }
        
        return cell
    }
    
}


