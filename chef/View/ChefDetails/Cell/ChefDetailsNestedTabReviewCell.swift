//
//  ChefDetailsNestedTabReviewCell.swift
//  chef
//
//  Created by Eddie Ha on 25/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Cosmos

class ChefDetailsNestedTabReviewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.Reviews.isEmpty{
            Tbl_Review.setEmptyMessage("No review avilable")
        }else{
            Tbl_Review.restore()
        }
        
        return self.plate.plateReviewList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Review_Cell") as! Review_Cell
        
        let review = self.Reviews[indexPath.row]
        cell.lblReviewUserNameOne.text = review.user?.name ?? ""
                        
        cell.uivRatingBarOne.rating = Double(review.rating ?? "") ?? 0.0
        cell.tfCommentOne.text = review.comment
        cell.userIconOne.setImageFromUrl(url: review.user?.imagePath ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    

    //MARK: Properties
    public let CLASS_NAME = ChefDetailsNestedTabReviewCell.self.description()
    open var plate = Plate(){
        didSet{
            guard let reviews = self.plate.plateReviewList else { return }
            print(reviews.count)
            if reviews.count > 0 {
                Reviews = reviews
                self.Tbl_Review.reloadData()
                
            }
        }
    }
    
    
    //MARK: Outlets
    @IBOutlet weak var lblReviewUserNameOne: UILabel!
    @IBOutlet weak var uivRatingBarOne: CosmosView!
    @IBOutlet weak var tfCommentOne: UITextView!
    @IBOutlet weak var lblReviewUsernameTwo: UILabel!
    @IBOutlet weak var uivRatingBarTwo: CosmosView!
    @IBOutlet weak var lblCommentTwo: UILabel!
    @IBOutlet weak var lblDateTwo: UILabel!
    @IBOutlet weak var userIconOne: UIImageView!
    @IBOutlet weak var userIconTwo: UIImageView!
    
    @IBOutlet weak var Tbl_Review: UITableView!
    var Reviews = [PlateReview]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let nibChefInfoCell = UINib(nibName: "Review_Cell", bundle: nil)
        self.Tbl_Review.register(nibChefInfoCell, forCellReuseIdentifier: "Review_Cell")
        self.Tbl_Review.delegate = self
        self.Tbl_Review.dataSource = self
        self.Tbl_Review.tableFooterView = UIView()
        lblReviewUserNameOne.text = "---"
        uivRatingBarOne.rating = 0
        tfCommentOne.text = "---"
        
        lblReviewUsernameTwo.text = "---"
        uivRatingBarTwo.rating = 0
        lblCommentTwo.text = "---"
        lblDateTwo.text = "--"
    }

}
