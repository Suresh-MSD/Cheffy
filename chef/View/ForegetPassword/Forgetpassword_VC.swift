
import UIKit

class Forgetpassword_VC: BaseViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        NextButton.layer.shadowColor = UIColor(red: 214.0/255.0, green: 65.0/255.0, blue: 64.0/255.0, alpha: 1.0).cgColor
        NextButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        NextButton.layer.shadowOpacity = 0.6
        NextButton.layer.shadowRadius = 10
        NextButton.layer.masksToBounds = false
        
    }
    
    
    @IBAction func NextButton(_ sender: UIButton) {
        
        if !Helper.isValidEmail(for: emailField.text!) || emailField.text == "" {
            showMessageWith("Invalid Email", "Please enter correct email", .warning)
            return
        }
        
        if isConnectedToNetwork() {
            ProgressViewHelper.show(type: .full)
            
            ForgetPasswordRequest(email: emailField.text ?? "").exec { [weak self] result, error in
                ProgressViewHelper.hide()
                if let data = result?.status {
                    
                    if data == 200 {
                    
                        self?.PushOTPScreen()
                        
                    } else if data == 404 {
                        
                        self?.showMessageWith("", result?.message, .warning)
                        
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

        
//
    }
    
    func PushOTPScreen() {
        
        let push = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "OTP_VC") as! OTP_VC
        push.UserEmail = emailField.text ?? ""
        self.navigationController?.pushViewController(push, animated: true)
    }

}
