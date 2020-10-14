

import UIKit
import FlagPhoneNumber

class PhoneNumberVC: BaseViewController {

    @IBOutlet weak var PhoneText: FPNTextField!
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
    
    @IBAction func CloseVC(_ sender: UIButton) {
           
           self.dismiss(animated: true, completion: nil)
    }

    @IBAction func NextButton(_ sender: UIButton) {
        
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
            
            SetUserPhoneNumber(country_code: PhoneText.text ?? "", phone_no: self.CountryCode).exec { [weak self] result, error in
                ProgressViewHelper.hide()
                if let data = result?.status {
                    
                    if data == 200 {
                    
                        print("success")
                        
                    } else {
                            
                        self?.showMessageWith("", result?.message, .info)
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
    
}

extension PhoneNumberVC : FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
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
