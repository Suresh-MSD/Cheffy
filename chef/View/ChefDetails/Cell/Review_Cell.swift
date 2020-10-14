

import UIKit
import Cosmos

class Review_Cell: UITableViewCell {

    @IBOutlet weak var lblReviewUserNameOne: UILabel!
    @IBOutlet weak var uivRatingBarOne: CosmosView!
    @IBOutlet weak var tfCommentOne: UITextView!
    @IBOutlet weak var userIconOne: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
