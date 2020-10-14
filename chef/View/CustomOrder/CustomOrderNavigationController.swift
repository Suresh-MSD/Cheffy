//
//  CustomOrderNavigationController.swift
//  chef
//
//  Created by Oluha group on 2019/10/03.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import ReSwift

class CustomOrderNavigationController: UINavigationController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeStateUpdate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.unsubscribeStateUpdate()
    }
}

extension CustomOrderNavigationController: StoreSubscriber {
    typealias StoreSubscriberStateType = User?
    
    func subscribeStateUpdate() {
        store.subscribe(self) { subcription in
            subcription.select { state in state.loginUser }
        }

        newState(state: store.state.loginUser)
    }
    
    func unsubscribeStateUpdate() {
        store.unsubscribe(self)
    }
    
    func newState(state: User?) {
        if let _ = state {
            if let _ = self.viewControllers[0] as? SessionStartViewController {
                self.setViewControllers([
                    UIStoryboard(name: "Home", bundle:nil).instantiateViewController(withIdentifier: "CustomOrderViewController")
                ], animated: false)
            }
        } else {
            if let _ = self.viewControllers[0] as? CustomOrderViewController {
                self.setViewControllers([
                    UIStoryboard(name: "Home", bundle:nil).instantiateViewController(withIdentifier: "SessionStartViewController")
                ], animated: false)
            }
        }
    }

}
