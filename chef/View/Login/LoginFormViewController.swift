//
//  LoginFormViewController.swift
//  chef
//
//  Created by Oluha group on 2019/10/28.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class LoginFormViewController: BaseViewController {
        
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    var IsShowPassword = false
    let facebookLoginButton = FBLoginButton()
    var googleSignIn = GIDSignIn.sharedInstance()

    var socialEmail : String?
    var socialProviderUserId : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        LoginButton.layer.shadowColor = UIColor(red: 214.0/255.0, green: 65.0/255.0, blue: 64.0/255.0, alpha: 1.0).cgColor
        LoginButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        LoginButton.layer.shadowOpacity = 0.6
        LoginButton.layer.shadowRadius = 10
        LoginButton.layer.masksToBounds = false
      
        //let facebookLoginButton = FBLoginButton(frame: .zero)
        facebookLoginButton.frame = .zero
        facebookLoginButton.permissions = ["public_profile","email","user_friends"];
        facebookLoginButton.delegate = self as? LoginButtonDelegate
        facebookLoginButton.isHidden = true

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
        facebookLoginButton.sendActions(for: .touchUpInside)
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func ForgetButton(_ sender: UIButton) {
        
        self.PushForgetScreen()
    }
    
    func PushForgetScreen() {
        
        let push = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Forgetpassword_VC") as! Forgetpassword_VC
        self.navigationController?.pushViewController(push, animated: true)
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
    
    func socialSignin(Email: String, Provider: String, ProviderUserId: String){
        self.view.endEditing(true)
        if isConnectedToNetwork() {
            ProgressViewHelper.show(type: .full)
            SocialRequest(email: Email, provider: Provider, provider_user_id: ProviderUserId).exec{ [weak self] result, error in
                //                    LoginRequest(login: emailField.text ?? "", password: passwordField.text ?? "").exec { [weak self] result, error in
                ProgressViewHelper.hide()
                if let data = result?.data, let token = result?.token {
                    store.dispatch(Actions.login(loginUser: data, token: token))
                    Helper.loggedIn(state: true)
                    Helper.saveUserToken(token: token)
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                } else if let message = result?.message{
                    self?.showMessageWith("", message, .error)
                } else {
                    self?.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        } else {
            showMessageWith(AlertKey, No_Internet_Connection, .error)
        }
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= (keyboardSize.height * 0.25)
//            }
//        }
//    }
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
    @IBAction func onPressLogin(_ sender: Any) {
        
        if !Helper.isValidEmail(for: emailField.text!) || emailField.text == "" {
            showMessageWith("Invalid Email", "Please enter correct email", .warning)
            return
        }
        
        if passwordField.text == "" {
            showMessageWith("Invalid Password", "Please enter correct password", .warning)
            return
        }
        self.view.endEditing(true)
        if isConnectedToNetwork() {
            ProgressViewHelper.show(type: .full)
            LoginRequest(login: emailField.text ?? "", password: passwordField.text ?? "").exec { [weak self] result, error in
                ProgressViewHelper.hide()
                if let data = result?.data, let token = result?.token {
                    store.dispatch(Actions.login(loginUser: data, token: token))
                    Helper.loggedIn(state: true)
                    Helper.saveUserToken(token: token)
//                    UserDefaultsHelper.LogedinUser = data
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                } else if let message = result?.message{
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

extension LoginFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension LoginFormViewController: GIDSignInDelegate {
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
        
        
        
        self.socialSignin(Email: userEmail, Provider: "google", ProviderUserId: userId)

    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

extension LoginFormViewController : LoginButtonDelegate{

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
                        print(" ----==> \(imageURL)")
                        self.socialProviderUserId = profile.userID

                    }
                    let connection = GraphRequestConnection()
                    let params = ["fields" : "email, name"]
                    
                    connection.add(GraphRequest(graphPath: "/me",parameters: params)) { httpResponse, result, error  in
                        print("Graph Request Succeeded: \(httpResponse)")
                        let result = result as? [String:String]
                        let email: String = result!["email"]!
                        self.socialEmail = email
                        self.socialSignin(Email: self.socialEmail!, Provider: "facebook", ProviderUserId: self.socialProviderUserId!)
                    }
                    connection.start()
                })
                
            }
//            SocialRequest(email:email, name: name, user_type: userType, provider: provider, provider_user_id: providerUserId, imagePath: imagePath).exec { [weak self] result, error in
            LoginRequest(login: emailField.text ?? "", password: passwordField.text ?? "").exec { [weak self] result, error in
                ProgressViewHelper.hide()
                if let data = result?.data, let token = result?.token {
                    store.dispatch(Actions.login(loginUser: data, token: token))
                    Helper.loggedIn(state: true)
                    Helper.saveUserToken(token: token)
                    //                    UserDefaultsHelper.LogedinUser = data
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                } else if let message = result?.message{
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
