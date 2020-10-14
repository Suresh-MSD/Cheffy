

import UIKit
import SkyFloatingLabelTextField

class Password_Verify_VC: BaseViewController {

    @IBOutlet weak var Img_User_Profile: UIImageView!
    @IBOutlet weak var Lbl_User_Name: UILabel!
    @IBOutlet weak var Lbl_User_Location: UILabel!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    var Current_user = User()
    var IsShowPassword = false
    
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
    
    @IBAction func CloseVC(_ sender: UIButton) {
          
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Change_Password_VC(_ sender: UIButton) {
          
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Set_New_Password_VC") as! Set_New_Password_VC
        vc.Current_user = self.Current_user
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension Password_Verify_VC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
