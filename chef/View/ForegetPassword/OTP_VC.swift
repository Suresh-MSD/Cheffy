
import UIKit

class OTP_VC: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var codeTxt1: UITextField!
    @IBOutlet weak var codeTxt2: UITextField!
    @IBOutlet weak var codeTxt3: UITextField!
    @IBOutlet weak var codeTxt4: UITextField!
    @IBOutlet weak var ContinueButton: UIButton!
    var otp : String?
    var UserEmail : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        codeTxt1.delegate = self
        codeTxt2.delegate = self
        codeTxt3.delegate = self
        codeTxt4.delegate = self
        
        
        codeTxt1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        codeTxt2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        codeTxt3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        codeTxt4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        ContinueButton.layer.shadowColor = UIColor(red: 214.0/255.0, green: 65.0/255.0, blue: 64.0/255.0, alpha: 1.0).cgColor
        ContinueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        ContinueButton.layer.shadowOpacity = 0.6
        ContinueButton.layer.shadowRadius = 10
        ContinueButton.layer.masksToBounds = false
    }
    
    @IBAction func CancelButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func ContinueButton(_ sender: UIButton) {
        
        if codeTxt1.text != "" && codeTxt2.text != "" && codeTxt3.text != "" && codeTxt4.text != "" {
            
            otp = codeTxt1.text!+codeTxt2.text!+codeTxt3.text!+codeTxt4.text!
            print(otp ?? "")
            
            if isConnectedToNetwork() {
                ProgressViewHelper.show(type: .full)
                
                CodeVerificationForgetPasswordRequest(email: self.UserEmail ?? "", email_token: Int(self.otp ?? "") ?? 0).exec { [weak self] result, error in
                    ProgressViewHelper.hide()
                    if let data = result?.status {
                        
                        if data == 202 {
                            self?.PushNewPasswordScreen()
                        } else if data == 409 {
                            self?.showMessageWith("", result?.message, .error)
                        } else {
                            self?.showMessageWith("", result?.message, .info)
                        }
                        
                        
                    } else if let message = result?.message {
                        self?.showMessageWith("", message, .info)
                    } else {
                        self?.showMessageWith("Error", Helper.ErrorMessage, .error)
                    }
                }
            } else {
                showMessageWith(AlertKey, No_Internet_Connection, .error)
            }
            
        } else {
            
            showMessageWith(AlertKey, "Enter verification code.", .error)
        }
        
    }
    
    func PushNewPasswordScreen() {
        
        let push = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SetNewForgetPassword_VC") as! SetNewForgetPassword_VC
        push.otp = self.otp ?? ""
        push.UserEmail = self.UserEmail ?? ""
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    //MARK:- ALL FUNCTIONS
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return range.location < 1
    }

    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        print(text)

        if (text?.utf16.count ?? 0) == 0 {
            switch textField{
            case codeTxt1:
                codeTxt1.becomeFirstResponder()
            case codeTxt2:
                codeTxt1.becomeFirstResponder()
            case codeTxt3:
                codeTxt2.becomeFirstResponder()
            case codeTxt4:
                codeTxt3.becomeFirstResponder()
            default:
                break
            }
        }
        
        if (text?.utf16.count ?? 0) >= 1{
            
            switch textField{
            case codeTxt1:
                codeTxt2.becomeFirstResponder()
            case codeTxt2:
                codeTxt3.becomeFirstResponder()
            case codeTxt3:
                codeTxt4.becomeFirstResponder()
            case codeTxt4:
                codeTxt4.resignFirstResponder()
            default:
                break
            }
        }else{

        }
    }

}
