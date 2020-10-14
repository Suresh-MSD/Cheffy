//
//  DigitCodeVerificationViewController.swift
//  chef
//
//  Created by Oluha group on 2019/11/02.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

class CodeVerificationViewController: BaseViewController,UITextFieldDelegate {
    

    
    @IBOutlet weak var codeTxt1: UITextField!
    @IBOutlet weak var codeTxt2: UITextField!
    @IBOutlet weak var codeTxt3: UITextField!
    @IBOutlet weak var codeTxt4: UITextField!
    
    var SignUp_User = User()

    var otp = String()
    
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
        
        print(self.SignUp_User.email ?? "")
    }
    
    //    MARK:- BUTTON ACCTION
    
    @IBAction func clickToSubmit(_ sender: Any) {
        
        if codeTxt1.text != "" && codeTxt2.text != "" && codeTxt3.text != "" && codeTxt4.text != "" {
            
            otp = codeTxt1.text!+codeTxt2.text!+codeTxt3.text!+codeTxt4.text!
            print(otp)
            
            if isConnectedToNetwork() {
                ProgressViewHelper.show(type: .full)
                
                CodeVerificationRequest(email: self.SignUp_User.email ?? "", email_token: self.otp).exec { [weak self] result, error in
                    ProgressViewHelper.hide()
                    if let data = result?.status {
                        
                        if data == 200 {
                            self?.showMessageWith("", result?.message, .success)
                            self?.pushNamePasswordScreen()
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
    
    func pushNamePasswordScreen() {
        
        let push = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Username_Password_VC") as! Username_Password_VC
        push.SignUp_User = self.SignUp_User
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @IBAction func btn_Action_to_Change_email_Address(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
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





