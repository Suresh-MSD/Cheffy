
import UIKit
import SkyFloatingLabelTextField

class Username_Password_VC: BaseViewController {
    
    @IBOutlet weak var NameField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    @IBOutlet weak var SignupButton: UIButton!
    @IBOutlet weak var PramoSwitch: UISwitch!
    var IsShowPassword = false
    var SignUp_User = User()
    
    var PramoFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        SignupButton.layer.shadowColor = UIColor(red: 214.0/255.0, green: 65.0/255.0, blue: 64.0/255.0, alpha: 1.0).cgColor
        SignupButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        SignupButton.layer.shadowOpacity = 0.6
        SignupButton.layer.shadowRadius = 10
        SignupButton.layer.masksToBounds = false
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func PasswordShowButton(_ sender: UIButton) {
        
        if !IsShowPassword {
            self.IsShowPassword = true
            self.passwordField.isSecureTextEntry = false
            sender.setTitle("Hide", for: .normal)
        } else {
            self.IsShowPassword = false
            self.passwordField.isSecureTextEntry = true
            sender.setTitle("Show", for: .normal)
        }
    }
    
    @IBAction func ChangePramoSwitch(_ sender: UISwitch) {
        
        PramoFlag = sender.isOn
        print(PramoFlag)
    }
    
    @IBAction func ClickSignUp(_ sender: UIButton) {
        
//        _ = self.navigationController?.popViewController(animated: true)
        
        if NameField.text == "" {
            showMessageWith("Invalid Entry", "Please enter Name", .warning)
            return
        }
        if passwordField.text == "" {
            showMessageWith("Invalid Entry", "Please enter Password", .warning)
            return
        }

        self.view.endEditing(true)
        if isConnectedToNetwork() {
            ProgressViewHelper.show(type: .full)

            NamePasswordRequest(email: SignUp_User.email ?? "", name: NameField.text ?? "", password: passwordField.text ?? "", user_type: "chef", restaurant_name: (NameField.text ?? "") + "'s", promotionalContent: self.PramoFlag).exec { [weak self] result, error in

                ProgressViewHelper.hide()
                if let data = result?.result {
                    print(data)
                    if (result?.status ?? 0) == 201 {
                        self?.showMessageWith("", result?.message ?? "", .success)
                        self?.showAlertAction(withTitle: "Congratulations!", message: "You have successfully created account. Would you like to login now?")
                    } else {
                        self?.showMessageWith("", result?.message ?? "", .error)
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
    
    func showAlertAction(withTitle title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            self.navigationController?.popToRootViewController(animated: false)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
}
