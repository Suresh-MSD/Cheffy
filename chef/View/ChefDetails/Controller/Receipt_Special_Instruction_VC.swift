import UIKit
import SwiftyJSON
class Receipt_Special_Instruction_VC: BaseViewController {

    @IBOutlet weak var LBL_Plate_Name: UILabel!
    @IBOutlet weak var LBL_Plate_Description: UILabel!
    @IBOutlet weak var Tbl_People_Added: UITableView!
    @IBOutlet weak var QuantityView: UIView!
    @IBOutlet weak var Btn_Add_Special: UIButton!
    @IBOutlet weak var Lbl_Quantity: UILabel!
    @IBOutlet weak var Lbl_Price: UILabel!
    @IBOutlet weak var TextView_Height: NSLayoutConstraint!
    @IBOutlet weak var TextView_AddSpecial: UITextView!
    
    var Cart_Plate = Plate()
    var Quntity = Int()
    var Total_price = Double()
    var selected_indexpath = [IndexPath]()
    var isOpen = false
    var People_Added_Array = [NSArray]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.Set_Data()
    }
    
    func Set_Data() {
        self.Tbl_People_Added.tableFooterView = UIView()
        
        TextView_AddSpecial.text = "Add your special instructions here"
        TextView_AddSpecial.textColor = UIColor.lightGray
        TextView_AddSpecial.delegate = self
        
        self.getPeopleAlsoAddedPlates(plateId: self.Cart_Plate.id ?? 0)
        let nibChefInfoCell = UINib(nibName: "People_Added_Cell", bundle: nil)
        self.Tbl_People_Added.register(nibChefInfoCell, forCellReuseIdentifier: "People_Added_Cell")
        self.Lbl_Price.text = "$\(self.Total_price)"
        self.Lbl_Quantity.text = "\(self.Quntity)"
        
        self.QuantityView.layer.cornerRadius = self.QuantityView.frame.size.height / 2
        self.LBL_Plate_Name.text = self.Cart_Plate.name
        self.LBL_Plate_Description.text = self.Cart_Plate.plateDescription
    }
    
    @IBAction func onClickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setPlatePrice(price:Int) -> Void {
        self.Lbl_Price.text = "$\(price)"
    }
    
    @IBAction func Btn_Increce(_ sender: UIButton) {
        self.Quntity += 1
        Lbl_Quantity.text = "\(self.Quntity)"
        self.setPlatePrice(price: self.Quntity * Int((Cart_Plate.price ?? 0)))
    }
    
    @IBAction func Btn_Decrese(_ sender: UIButton) {
       if self.Quntity > 1{
           self.Quntity -= 1
           Lbl_Quantity.text = "\(self.Quntity)"
           self.setPlatePrice(price: self.Quntity * Int((Cart_Plate.price ?? 0)))
       }
    }
    
    @IBAction func Btn_Add_To_Cart(_ sender: UIButton) {
       
        if !Helper.isLoggedIn() {
            SnackbarCollection.showSnackbarWithText(text: "Login to Add To Cart.")
            return
        }
        ProgressViewHelper.show(type: .full)
        
        let url = "\(ApiEndpoints.URI_ADD_PLATE_TO_CART)"

        let Item_Array = [["quantity":self.Quntity,"plateId":Cart_Plate.id ?? 0]]
        let parameter = ["plates":Item_Array]

        CartService.getInstance().addPlateToCartRequest(url: url, parameters: parameter , completionHandler: {response in


            if response.result.isSuccess {
                ProgressViewHelper.hide()
                //                let json = JSON(response.data!)
                self.showMessageWith("", "Added this plate to your cart successfully", .success)
                self.navigationController?.popViewController(animated: true)
            }
        })
        
    }
    
    
    
    @IBAction func Click_Add_Special(_ sender: UIButton) {
        
        if !isOpen {
            self.isOpen = true
            
            UIView.animate(withDuration: 0.3) {
                sender.transform = sender.transform.rotated(by: CGFloat((Double.pi / 2)))
                self.TextView_Height.constant = 100.0
                self.view.layoutIfNeeded()
            }
            
        } else {
            self.isOpen = false
            
            UIView.animate(withDuration: 0.3) {
                sender.transform = sender.transform.rotated(by: CGFloat(-(Double.pi / 2)))
                self.TextView_Height.constant = 0.0
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
    @objc func Click_Check(sender:UIButton) {
        
        let Row = sender.tag - 1000
        let cell = Tbl_People_Added.cellForRow(at: IndexPath(item: Row, section: 0)) as! People_Added_Cell
        if cell.Btn_Check.imageView?.image == UIImage(named: "ic_selected-1") {
            let index = self.selected_indexpath.index(of: IndexPath(item: Row, section: 0))
            self.selected_indexpath.remove(at: index ?? 0)
            cell.Btn_Check.setImage(UIImage(named: "ic_unselect"), for: .normal)
        } else {
            selected_indexpath.append(IndexPath(item: Row, section: 0))
            cell.Btn_Check.setImage(UIImage(named: "ic_selected-1"), for: .normal)
        }
        
    }
    
    private func getPeopleAlsoAddedPlates(plateId: Int) -> Void {
        let url = ApiEndpoints.URI_GET_PEOPLE_ADDED + "/\(plateId)"
        
        FoodCategoryService.getInstance().getRequest(url: url, completionHandler: { [weak self]
            response in
            ProgressViewHelper.hide()
            if let strongSelf = self {
                print("url = \(url),  response = \(response)")
                if response.result.isSuccess{
                    let json = JSON(response.data!)
                    if json.arrayValue.count != 0 {
                        
                        self?.Tbl_People_Added.reloadData()
                        
                        let item = json["data"].dictionaryValue
                        if !item.isEmpty{
                                
                        }
                        
                    } else {
                        self?.Tbl_People_Added.reloadData()
                    }
                    
                    
                } else {
                    strongSelf.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        })
    }

}

extension Receipt_Special_Instruction_VC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if People_Added_Array.isEmpty{
            Tbl_People_Added.setEmptyMessage("No item avilable")
        }else{
            Tbl_People_Added.restore()
        }
        
        return People_Added_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "People_Added_Cell", for: indexPath) as! People_Added_Cell
        cell.Btn_Check.addTarget(self, action: #selector(self.Click_Check(sender:)), for: .touchUpInside)
        cell.Btn_Check.tag = 1000 + indexPath.row
        
        if self.selected_indexpath.contains(indexPath) {
            cell.Btn_Check.setImage(UIImage(named: "ic_selected-1"), for: .normal)
        } else {
            cell.Btn_Check.setImage(UIImage(named: "ic_unselect"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = Tbl_People_Added.cellForRow(at: indexPath) as! People_Added_Cell
        if cell.Btn_Check.imageView?.image == UIImage(named: "ic_selected-1") {
            let index = self.selected_indexpath.index(of: indexPath)
            self.selected_indexpath.remove(at: index ?? 0)
            cell.Btn_Check.setImage(UIImage(named: "ic_unselect"), for: .normal)
        } else {
            selected_indexpath.append(indexPath)
            print(self.selected_indexpath)
            cell.Btn_Check.setImage(UIImage(named: "ic_selected-1"), for: .normal)
        }
    }
}

extension Receipt_Special_Instruction_VC:UITextViewDelegate {
    
    //MARK: Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add your special instructions here"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
