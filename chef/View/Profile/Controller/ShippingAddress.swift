
import UIKit
import SwiftyJSON

class ShippingAddress: BaseViewController {
    
    @IBOutlet weak var BtnAddAddress: UIButton!
    @IBOutlet weak var TblAddressList: UITableView!
    
    private var userShippingAddress = [UserShippingAddress]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
    }
    
    private func initialize() -> Void {
        
        //Add Address BTN
        self.BtnAddAddress.cornerRadius = self.BtnAddAddress.frame.height / 2
        self.BtnAddAddress.layer.shadowColor = UIColor.gray.cgColor
        self.BtnAddAddress.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.BtnAddAddress.layer.shadowOpacity = 0.6
        self.BtnAddAddress.layer.shadowRadius = 10
        self.BtnAddAddress.layer.masksToBounds = false
        
        //TableView
        self.TblAddressList.tableFooterView = UIView()
        self.TblAddressList.register(UINib(nibName: "ShippingAddressCell", bundle: nil), forCellReuseIdentifier: "ShippingAddressCell")
        
        self.TblAddressList.delegate = self
        self.TblAddressList.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isConnectedToNetwork() {
            reload()
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }
    }
    
    func reload() {
        
        self.userShippingAddress.removeAll()
        self.getUserShippingAddress()
    }
    
    //MARK: Actions
    //when click on back button
    @IBAction func onClickbackButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnClickAddShipping(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserProfileShippingViewController") as! UserProfileShippingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //get user shipping address
    private func getUserShippingAddress() {
        
        ProgressViewHelper.show(type: .full)
        
        let url = ApiEndpoints.URI_GET_USER_SHIPPING_ADRESS
        
        UserProfileService.getInstance().getUserShippingAddress(url: url, completionHandler: {
            response in
            
            ProgressViewHelper.hide()
            
            if response.result.isSuccess{
                let json = JSON(response.data!)
                print(json)
                let add_data = json["data"].arrayValue
                if !add_data.isEmpty {
                    
                    for Address in add_data {
                        
                        let Shipping_Address = UserShippingAddress()
                        
                        Shipping_Address.id = Address["id"].int
                        Shipping_Address.userId = Address["userId"].int
                        Shipping_Address.addressLine1 = Address["addressLine1"].string
                        Shipping_Address.addressLine2 = Address["addressLine2"].string
                        Shipping_Address.city = Address["city"].string
                        Shipping_Address.state = json["state"].string
                        Shipping_Address.zipCode = Address["zipCode"].string
                        Shipping_Address.lattitude = Address["lat"].string
                        Shipping_Address.longitude = Address["lon"].string
                        Shipping_Address.isDefaultAddress = Address["isDefaultAddress"].bool
                        Shipping_Address.deliveryNote = Address["deliveryNote"].stringValue
                        
                        self.userShippingAddress.append(Shipping_Address)
                    }
                    self.TblAddressList.reloadData()
                } else {
                    self.showMessageWith("", "No Shipping Address Found", .info)
                }
            }
        })
    }
    
    //get user shipping address
    private func SetDefaultShippingAddress(shippingID : Int) {
        
        ProgressViewHelper.show(type: .full)
        
        let url = ApiEndpoints.URI_GET_USER_SHIPPING_ADRESS + "/\(shippingID)/set-default"
        
        UserProfileService.getInstance().setdefalutAddress(url: url, completionHandler: {
            response in
            
            ProgressViewHelper.hide()
            if response.result.isSuccess{
                let json = JSON(response.data!)
                let add_data = json["message"].string
                self.showMessageWith("", add_data, .info)
                self.reload()
            }
        })
    }
}

extension ShippingAddress : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.userShippingAddress.isEmpty {
            
            tableView.setEmptyMessage("Shipping address appear here")
        } else {
            tableView.restore()
        }
        return self.userShippingAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ShippingAddressCell", for: indexPath) as! ShippingAddressCell
        
        let Address = self.userShippingAddress[indexPath.row]
        
        Cell.LBLAddressLine?.text = Address.addressLine1 ?? ""
        Cell.LBLState?.text = Address.addressLine2 ?? ""
        if (Address.isDefaultAddress ?? false) == true {
            Cell.accessoryType = .checkmark
        } else {
            Cell.accessoryType = .none
        }
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Address = self.userShippingAddress[indexPath.row]
        self.SetDefaultShippingAddress(shippingID: Address.id ?? 0)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let share = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserProfileShippingViewController") as! UserProfileShippingViewController
            vc.IsEdit = true
            vc.EditUserShippingAddress = self.userShippingAddress[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        }

        share.backgroundColor = UIColor(red: 63/255.0, green: 55/255.0, blue: 172/255.0, alpha: 1.0)

        let Delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            
            let Delete_Alewrt = UIAlertController(title: "Delete address", message: "Are you sure you want to delete this address?", preferredStyle: .alert)
            let Yes = UIAlertAction(title: "Yes", style: .default) { (Success) in
                
                let shippingID = self.userShippingAddress[indexPath.row].id ?? 0
                
                let url = ApiEndpoints.URI_GET_USER_SHIPPING_ADRESS + "/\(shippingID)"
                
                UserProfileService.getInstance().DeleteAddress(url: url, completionHandler: {
                    response in
                    
                    ProgressViewHelper.hide()
                    if response.result.isSuccess{
                        let json = JSON(response.data!)
                        let Delete_data = json["message"].string
                        self.showMessageWith("", Delete_data, .info)
                        self.reload()
                    }
                })

                
            }
            
            let No = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            Delete_Alewrt.addAction(No)
            Delete_Alewrt.addAction(Yes)
            
            self.present(Delete_Alewrt, animated: true, completion: nil)
            
            
            
        }

        Delete.backgroundColor = UIColor(red: 234/255.0, green: 29/255.0, blue: 44/255.0, alpha: 1.0)
        
        return [Delete,share]
    }
}
