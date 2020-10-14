
import UIKit
import SwiftyJSON

protocol SelectPaymentCart: class {
    func getPaymentData(card: UserCardDetail)
}

class UserCardListVC: BaseViewController {

    @IBOutlet weak var BtnAddCard: UIButton!
    @IBOutlet weak var TblCardsList: UITableView!
    
    var User_Card_Details = [UserCardDetail]()
    
    weak var delegate: SelectPaymentCart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    private func initialize() -> Void {
        
        //Add Address BTN
        self.BtnAddCard.cornerRadius = self.BtnAddCard.frame.height / 2
        self.BtnAddCard.layer.shadowColor = UIColor.gray.cgColor
        self.BtnAddCard.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.BtnAddCard.layer.shadowOpacity = 0.6
        self.BtnAddCard.layer.shadowRadius = 10
        self.BtnAddCard.layer.masksToBounds = false
        
        //TableView
        self.TblCardsList.tableFooterView = UIView()
        self.TblCardsList.register(UINib(nibName: "ShippingAddressCell", bundle: nil), forCellReuseIdentifier: "ShippingAddressCell")
        
        self.TblCardsList.delegate = self
        self.TblCardsList.dataSource = self
        
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
        
        self.User_Card_Details.removeAll()
        self.GetCards()
    }
    
    //MARK: Actions
    //when click on back button
    @IBAction func onClickbackButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnClickAddCard(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserProfilePaymentViewController") as! UserProfilePaymentViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func GetCards() {
        
        ProgressViewHelper.show(type: .full)
        
        let url = ApiEndpoints.URI_POST_CARD_DETAILS
        
        UserProfileService.getInstance().getUserCard(url: url, completionHandler: {
            response in
            
            ProgressViewHelper.hide()
            
            if response.result.isSuccess{
                let json = JSON(response.data!)
                print(json)
                let add_data = json["data"].arrayValue
                if !add_data.isEmpty {
                    
                    for Cards in add_data {
                        
                        let user_card = UserCardDetail()
                        user_card.id = Cards["id"].string
                        user_card.object = Cards["object"].string
                        user_card.created = Cards["created"].int
                        user_card.customer = Cards["customer"].string
                        user_card.livemode = Cards["livemode"].bool
                        user_card.type = Cards["type"].string
                        
                        let Dic_Billing = Cards["billing_details"].dictionary
                        let User_Billing_Details = BillingDetails()
                        User_Billing_Details.email = Dic_Billing?["email"]?.string
                        User_Billing_Details.name = Dic_Billing?["name"]?.string
                        User_Billing_Details.phone = Dic_Billing?["phone"]?.string
                        user_card.billing_details = User_Billing_Details
                        
                        let Dic_Address = Dic_Billing?["address"]?.dictionary
                        let User_Address_Details = Address()
                        User_Address_Details.city = Dic_Address?["city"]?.string
                        User_Address_Details.country = Dic_Address?["country"]?.string
                        User_Address_Details.line1 = Dic_Address?["line1"]?.string
                        User_Address_Details.line2 = Dic_Address?["line2"]?.string
                        User_Address_Details.postal_code = Dic_Address?["postal_code"]?.string
                        User_Address_Details.state = Dic_Address?["state"]?.string
                        user_card.address = User_Address_Details
                        
                        let Dic_Card = Cards["card"].dictionary
                        let User_Card_Details = UserCard()
                        User_Card_Details.brand = Dic_Card?["brand"]?.string
                        User_Card_Details.country = Dic_Card?["country"]?.string
                        User_Card_Details.exp_month = Dic_Card?["exp_month"]?.int
                        User_Card_Details.exp_year = Dic_Card?["exp_year"]?.int
                        User_Card_Details.fingerprint = Dic_Card?["fingerprint"]?.string
                        User_Card_Details.funding = Dic_Card?["funding"]?.string
                        User_Card_Details.generated_from = Dic_Card?["generated_from"]?.string
                        User_Card_Details.last4 = Dic_Card?["last4"]?.string
                        User_Card_Details.wallet = Dic_Card?["wallet"]?.string
                        user_card.card = User_Card_Details
                        
                        let Dic_Checks = Dic_Card?["checks"]?.dictionary
                        let User_Checks_Details = UserCardChecks()
                        User_Checks_Details.address_line1_check = Dic_Checks?["address_line1_check"]?.string
                        User_Checks_Details.address_postal_code_check = Dic_Checks?["address_postal_code_check"]?.string
                        User_Checks_Details.cvc_check = Dic_Checks?["cvc_check"]?.string
                        user_card.checks = User_Checks_Details
                        
                        let Dic_3D = Dic_Card?["three_d_secure_usage"]?.dictionary
                        let User_3D_Details = UserCardChecks_3D()
                        User_3D_Details.supported = Dic_3D?["supported"]?.bool
                        user_card.three_d_secure_usage = User_3D_Details
                        
                        self.User_Card_Details.append(user_card)
                    }
//                    print(self.User_Card_Details.count)
                    self.TblCardsList.reloadData()
                } else {
                    self.showMessageWith("", json["message"].string, .info)
                }
            }
        })
    }

}

extension UserCardListVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.User_Card_Details.isEmpty {
            
            tableView.setEmptyMessage("Card's details appear here")
        } else {
            tableView.restore()
        }
        return self.User_Card_Details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ShippingAddressCell", for: indexPath) as! ShippingAddressCell
        
        let Card = self.User_Card_Details[indexPath.row]
        
        Cell.LBLAddressLine?.text = "**** **** **** \(Card.card?.last4 ?? "")"
        Cell.LBLState?.text = Card.card?.brand ?? ""
        Cell.Img.image = UIImage(named: "ic_card")
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            
            let Card = self.User_Card_Details[indexPath.row]
            delegate.getPaymentData(card: Card)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
          
           let Delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
               
               let Delete_Alewrt = UIAlertController(title: "Delete card", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
               let Yes = UIAlertAction(title: "Yes", style: .default) { (Success)
    in
                   let CardID = self.User_Card_Details[indexPath.row].id ?? ""
                   
                   let url = ApiEndpoints.URI_POST_CARD_DETAILS + "/\(CardID)"
                   
                   
                   AddCardDetailsService.getInstance().DeleteCard(url: url, completionHandler: {
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

           Delete.backgroundColor = UIColor.red

           return [Delete]
       }
}
