//
//  BackgroundThread.swift
//  chef
//
//  Created by Eddie Ha on 27/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class BackgroundThread: NSObject {
    class BackgroundThread: NSObject {
        public static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
            DispatchQueue.global(qos: .background).async {
                background?()
                if let completion = completion {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                        completion()
                    })
                }
            }
        }
    }
    

}
