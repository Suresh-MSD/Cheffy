

import UIKit
import SkyFloatingLabelTextField

class Set_New_Password_VC: UIViewController {

    @IBOutlet weak var Img_User_Profile: UIImageView!
    @IBOutlet weak var Lbl_User_Name: UILabel!
    @IBOutlet weak var Lbl_User_Location: UILabel!
    @IBOutlet weak var Btn_save: UIButton!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    @IBOutlet weak var NewpasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var ConfirmpasswordField: SkyFloatingLabelTextField!
    
    var Current_user = User()
    var IsShowPassword = false
    var IsShowNewPassword = false
    var IsShowConfirmPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.delegate = self
        
        if let url = Current_user.imagePath {
            Img_User_Profile.setImageFromUrl(url: url)
            
        }else{
            //iconImage.backgroundColor = .lightGray
            Img_User_Profile.image = #imageLiteral(resourceName: "user_placeholder")
        }
        Img_User_Profile.backgroundColor = .clear
        Lbl_User_Name.text = Current_user.name
        Lbl_User_Location.text = Current_user.defaultAddress
        passwordField.text = Current_user.password ?? ""
        
        Btn_save.layer.shadowColor = UIColor(red: 214.0/255.0, green: 65.0/255.0, blue: 64.0/255.0, alpha: 1.0).cgColor
        Btn_save.layer.shadowOffset = CGSize(width: 0, height: 0)
        Btn_save.layer.shadowOpacity = 0.6
        Btn_save.layer.shadowRadius = 10
        Btn_save.layer.masksToBounds = false
        
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
    
    @IBAction func NewPasswordShowButton(_ sender: UIButton) {
        
        if !IsShowNewPassword {
            self.IsShowNewPassword = true
            self.NewpasswordField.isSecureTextEntry = false
            sender.setTitle("Hide", for: .normal)
        } else {
            self.IsShowNewPassword = false
            self.NewpasswordField.isSecureTextEntry = true
            sender.setTitle("Show", for: .normal)
        }
    }
    
    @IBAction func ConfirmPasswordShowButton(_ sender: UIButton) {
        
        if !IsShowConfirmPassword {
            self.IsShowConfirmPassword = true
            self.ConfirmpasswordField.isSecureTextEntry = false
            sender.setTitle("Hide", for: .normal)
        } else {
            self.IsShowConfirmPassword = false
            self.ConfirmpasswordField.isSecureTextEntry = true
            sender.setTitle("Show", for: .normal)
        }
    }
    @IBAction func CloseVC(_ sender: UIButton) {
              
            self.navigationController?.popViewController(animated: true)
    }
        
        
        
}

extension Set_New_Password_VC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
