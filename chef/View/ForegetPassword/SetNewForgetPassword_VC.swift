
import UIKit

class SetNewForgetPassword_VC: BaseViewController {

    var otp : String?
    var UserEmail : String?
    
    @IBOutlet weak var NewPasswordText: UITextField!
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
        
        self.view.endEditing(true)
        
        if NewPasswordText.text != "" {
            
            if !self.isValidPassword(testPwd: NewPasswordText.text) {
                self.showPasswordAlertAction(withTitle: "Attention!", message: "Use Valid Characters including One Uppercase,One Lowercase,One Special Character and One Digit with minimum 8 character length.")
                return
            }
            
            if isConnectedToNetwork() {
                ProgressViewHelper.show(type: .full)
                
                NewResetPasswordRequest(email: self.UserEmail ?? "", email_token: Int(self.otp ?? "") ?? 0 , newPassword: NewPasswordText.text ?? "").exec { [weak self] result, error in
                    ProgressViewHelper.hide()
                    if let data = result?.status {
                        
                        print(data)
                        if data == 202 {
//                            self?.showMessageWith("", result?.message ?? "", .success)
                            self?.showAlertAction(withTitle: "Congratulations!", message: "Password successfully reset! Would you like to login now?")
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
   

    func showAlertAction(withTitle title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            self.navigationController?.popToRootViewController(animated: false)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showPasswordAlertAction(withTitle title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
//            self.navigationController?.popToRootViewController(animated: false)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    func isValidPassword(testPwd : String?) -> Bool{
        guard testPwd != nil else {
            return false
        }
        let passwordPred = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
        return passwordPred.evaluate(with: testPwd)
    }
    
}
