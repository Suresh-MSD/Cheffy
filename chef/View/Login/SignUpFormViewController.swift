//
//  LoginFormViewController.swift
//  chef
//
//  Created by Oluha group on 2019/10/28.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

@available(iOS 13.0, *)
class SignUpFormViewController: BaseViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    var SignUp_User = User()
    let facebookSignupButton = FBLoginButton()
    var googleSignIn = GIDSignIn.sharedInstance()

    var socialEmail : String?
    var socialName  : String?
    var socialProviderUserId : String?
    var socialImagePath : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        
        NextButton.layer.shadowColor = UIColor(red: 214.0/255.0, green: 65.0/255.0, blue: 64.0/255.0, alpha: 1.0).cgColor
        NextButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        NextButton.layer.shadowOpacity = 0.6
        NextButton.layer.shadowRadius = 10
        NextButton.layer.masksToBounds = false
        
          signUpButton.layer.shadowColor = UIColor(red: 214.0/255.0, green: 65.0/255.0, blue: 64.0/255.0, alpha: 1.0).cgColor
          signUpButton.layer.shadowOffset = CGSize(width: 0, height: 0)
          signUpButton.layer.shadowOpacity = 0.6
          signUpButton.layer.shadowRadius = 10
          signUpButton.layer.masksToBounds = false
        
          //let facebookLoginButton = FBLoginButton(frame: .zero)
          facebookSignupButton.frame = .zero
          facebookSignupButton.permissions = ["public_profile","email","user_friends"];
          facebookSignupButton.delegate = self as? LoginButtonDelegate
          facebookSignupButton.isHidden = true

        self.socialRegister(Email: "", Name: "Test1", UserType: "user", ProviderType: "facebook", ProviderUserId: "121312312334", ImagePath: "www.test1.jpg");

        
    }
    
    @IBAction func googleLoginBtnAction(_ sender: UIButton) {
        self.googleAuthLogin()
    }
    
    func googleAuthLogin() {
        self.googleSignIn?.presentingViewController = self
        self.googleSignIn?.clientID = "785836444326-arm0arq7fqn3n2qp5fvf055qp0tehiok.apps.googleusercontent.com"
        self.googleSignIn?.delegate = self
        self.googleSignIn?.signIn()
    }

    @IBAction func registerWithFacebook(_ sender: UIButton) {
        facebookSignupButton.sendActions(for: .touchUpInside)
    }

    
//    MARK:- BUTTON ACTION
    
    @IBAction func btn_Action_For_next(_ sender: Any)
    {
        if !Helper.isValidEmail(for: emailField.text!) || emailField.text == "" {
            showMessageWith("Invalid Email", "Please enter correct email", .warning)
            return
        }
        self.view.endEditing(true)
        if isConnectedToNetwork() {
            
//            ProgressViewHelper.show(type: .full)
            
            self.pushPhoneNumberScreen()
            
//            SignUpRequest(email: emailField.text ?? "").exec { [weak self] result, error in
//                ProgressViewHelper.hide()
//                if let data = result?.result {
//
//                    if (data.password_generated ?? true) == true {
//
//                        self?.SignUp_User = data
//                        self?.SignUp_User.email = self?.emailField.text ?? ""
//                        self?.pushNamePasswordScreen()
//
//                    } else if (result?.message ?? "") == Registered_User {
//
//                        self?.showMessageWith("", Registered_User, .info)
//
//                    } else {
//
//                        self?.SignUp_User = data
//                        self?.pushVerificationScreen()
//                    }
//
//                } else if let message = result?.message {
//                    self?.showMessageWith("", message, .error)
//                } else {
//                    self?.showMessageWith("Error", Helper.ErrorMessage, .error)
//                }
//            }
            
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }
    }
    
    func pushVerificationScreen() {
        
        let push = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "CodeVerificationViewController") as! CodeVerificationViewController
        push.SignUp_User = self.SignUp_User
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    func pushPhoneNumberScreen() {
        
        let push = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Register_Phone_VC") as! Register_Phone_VC
//        push.SignUp_User = self.SignUp_User
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    func pushNamePasswordScreen() {
        
        let push = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Username_Password_VC") as! Username_Password_VC
        push.SignUp_User = self.SignUp_User
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    func socialRegister(Email:String, Name:String, UserType:String,ProviderType:String,ProviderUserId:String, ImagePath:String){
        
        SocialSignUpRequest(email: Email, name: Name, user_type: UserType, provider: ProviderType, provider_user_id: ProviderUserId, imagePath: ImagePath).exec { [weak self] result, error in
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


@available(iOS 13.0, *)
extension SignUpFormViewController: GIDSignInDelegate {
     func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let user = user else {
            print("Uh oh. The user cancelled the Google login.")
            return
        }
        let userId = user.userID ?? ""
        print("Google User ID: \(userId)")
        
        let userIdToken = user.authentication.idToken ?? ""
        print("Google ID Token: \(userIdToken)")
        
        let userFirstName = user.profile.givenName ?? ""
        print("Google User First Name: \(userFirstName)")
        
        let userLastName = user.profile.familyName ?? ""
        print("Google User Last Name: \(userLastName)")
        
        let userEmail = user.profile.email ?? ""
        print("Google User Email: \(userEmail)")
        
        let googleProfilePicURL = user.profile.imageURL(withDimension: 150)?.absoluteString ?? ""
        print("Google Profile Avatar URL: \(googleProfilePicURL)")
        
        self.socialRegister(Email: userEmail, Name: userFirstName, UserType: "user", ProviderType: "google", ProviderUserId: userId, ImagePath: googleProfilePicURL);
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

@available(iOS 13.0, *)
extension SignUpFormViewController : LoginButtonDelegate{
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        getUserDataFromFacebook()
    }
    
    func getUserDataFromFacebook() {
        
        if isConnectedToNetwork() {
            ProgressViewHelper.show(type: .full)
            
            if (AccessToken.isCurrentAccessTokenActive) {
                //            GraphRequest.init(graphPath: "me", parameters: nil)
                // User is logged in, do work such as go to next view controller.
                Profile.loadCurrentProfile(completion: { profile, error in
                    if let profile = profile {
                        
                        let imageURL = profile.imageURL(forMode: .square, size: CGSize(width: 200.0, height: 200.0))
                        self.socialName = profile.firstName!
                        self.socialImagePath = imageURL!.absoluteString
                        self.socialProviderUserId = profile.userID
                        print(self.socialName, profile.firstName)
                        print(self.socialImagePath, imageURL!.absoluteString)
                        print(self.socialProviderUserId, profile.userID)

                        print(profile)
                        let connection = GraphRequestConnection()
                        let params = ["fields" : "email, name"]
                        connection.add(GraphRequest(graphPath: "/me",parameters: params)) { httpResponse, result, error  in
                            let result = result as? [String:String]
                            let email: String = result!["email"]!
                            self.socialEmail = email
                            print(result!["email"], email, self.socialEmail)
                            self.socialRegister(Email: self.socialEmail!, Name: self.socialName!, UserType: "user", ProviderType: "facebook", ProviderUserId: self.socialProviderUserId!, ImagePath: self.socialImagePath!);

                        }
                        connection.start()
                    }
                })
            }
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }
    }
}
@available(iOS 13.0, *)
extension SignUpFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

