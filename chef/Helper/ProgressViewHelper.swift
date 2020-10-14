//
//  ProgressViewHelper.swift
//  chef
//
//  Created by Oluha group on 2019/09/30.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import SVProgressHUD

class ProgressViewHelper {
    enum VisibleType {
        case normal
        case full
    }
    
    static func show(type: VisibleType?) {

        // If SVProgressHUD is already displayed, return
        if SVProgressHUD.isVisible()  {
            return
        }

        let type: VisibleType = type ?? .normal
        switch type {
        case .full:
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundLayerColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3))
            SVProgressHUD.show()
            
        default:
            SVProgressHUD.setDefaultMaskType(.none)
            SVProgressHUD.setBackgroundLayerColor(.clear) // you
            SVProgressHUD.show()
        }
    }
    
    static func hide() {
        SVProgressHUD.dismiss()
    }
    
    static func showError(message: String) {
        SVProgressHUD.showError(withStatus: message)
    }
}
