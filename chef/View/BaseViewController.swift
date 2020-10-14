//
//  BaseViewController.swift
//  chef
//
//  Created by Bola Ibrahim on 11/16/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import ISMessages
import SystemConfiguration

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //----------------------------------------------------------------------
    // MARK:- Check Internet Connection
    //----------------------------------------------------------------------
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    
    //----------------------------------------------------------------------
    // MARK:- Show Alert Message
    //----------------------------------------------------------------------

    func showAlert(withTitle title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func alertYesNo(title: String , message: String, completion: ((Bool?) -> Void)? = nil){
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            completion?(true)
        }
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title:"No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            completion?(false)
            return
        }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showMessageWith(_ title: String, _ message: String?, _ type: ISAlertType) {
        ISMessages.showCardAlert(withTitle: title, message: message, duration: 2.0, hideOnSwipe: true, hideOnTap: true, alertType: type, alertPosition: .top, didHide: nil)
    }
}
