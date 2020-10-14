

import UIKit
import FlagPhoneNumber

class Register_Phone_VC: BaseViewController {

    @IBOutlet weak var PhoneText: FPNTextField!
    @IBOutlet weak var Btn_Select_Country: UIButton!
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    var ValidNumber = false
    var CountryCode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PhoneText.displayMode = .list // .picker by default
        PhoneText.delegate = self
        listController.setup(repository: PhoneText.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.PhoneText.setFlag(countryCode: country.code)
            self?.CountryCode = "\(country.phoneCode)"
            
        }
    }
    
    @IBAction func Click_Select_Country(_ sender: Any)
    {
        PhoneText.flagButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func Click_Change_Email(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Click_Continue(_ sender: Any)
    {
        self.CountryCode = self.PhoneText.selectedCountry?.phoneCode ?? ""
        print(self.CountryCode)
        if PhoneText.text == "" {
           showMessageWith("", "Please enter phone number", .warning)
           return
        } else if !ValidNumber {
            showMessageWith("", "Please enter valid phone number", .warning)
            return
        }
        
        if isConnectedToNetwork() {
            
            ProgressViewHelper.show(type: .full)
            
            SetUserPhoneNumber(country_code: self.CountryCode, phone_no: PhoneText.text ?? "" ).exec { [weak self] result, error in
                ProgressViewHelper.hide()
                if let data = result?.status {
                    
                    if data == 200 {
                    
                        print("success")
                        
                    } else {
                            
                        self?.showMessageWith("", "Internal Server Error", .info)
                    }
                    
                } else if let message = result?.message {
                    self?.showMessageWith("", message, .error)
                } else {
                    self?.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }

    }
    
    func pushVerificationScreen() {
        
        let push = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "CodeVerificationViewController") as! CodeVerificationViewController
//        push.SignUp_User = self.SignUp_User
        self.navigationController?.pushViewController(push, animated: true)
    }
    
}

extension Register_Phone_VC : FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
        self.Btn_Select_Country.setTitle("\(code)", for: .normal)
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
           print("Valid")
            self.ValidNumber = true
                                        // Output "600000001"
        } else {
           print("Invalid")
            self.ValidNumber = false
        }
    }
    
    func fpnDisplayCountryList() {
        
        let navigationViewController = UINavigationController(rootViewController: listController)
        listController.title = "Countries"
        
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    
}
