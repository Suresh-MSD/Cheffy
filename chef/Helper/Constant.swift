//
//  Constant.swift
//  chef
//
//  Created by Pulkit on 04/01/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import UIKit
import Foundation

let AlertKey = "Alert!"
let No_Internet_Connection = "No Internet Connectoin"
let Registered_User = "Already registered user"

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(NSURL(string: url)! as URL) {
                application.openURL(NSURL(string: url)! as URL)
                return
            }
        }
    }
}

class UserDefaultsHelper {
    
    static var LogedinUser: User? {
        get {
            if let archivedData = UserDefaults.standard.object(forKey: "LogedinUser") as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? User
            } else {
                return nil
            }
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: "LogedinUser")
            } else {
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue!), forKey: "LogedinUser")
            }
        }
    }
}

class LeftAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2, bottom: 0, right: 0)
    }
}

extension UIImage {

    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }

}
