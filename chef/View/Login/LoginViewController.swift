//
//  LoginViewController.swift
//  chef
//
//  Created by Eddie Ha on 13/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import CarbonKit

class LoginViewController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    @IBOutlet weak var tab: UISegmentedControl!
    @IBOutlet weak var pager: UIScrollView!
    @IBOutlet weak var loginForm: UIView!
    @IBOutlet weak var signUpForm: UIView!
    
    @IBOutlet var CarbonView: UIView!
    var Title_Names = [String]()
    var isTabSelected = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Title_Names = ["Log in", "Signup"]
        
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: Title_Names, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: self.CarbonView)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(CGFloat(roundf(Float(self.view.bounds.size.width / 2))), forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(CGFloat(roundf(Float(self.view.bounds.size.width / 2))), forSegmentAt: 1)
        
        carbonTabSwipeNavigation.carbonSegmentedControl?.backgroundColor = UIColor.white
        carbonTabSwipeNavigation.setSelectedColor(OriginalColors.primary.uiColor(), font: UIFont.boldSystemFont(ofSize: 15.0))
        carbonTabSwipeNavigation.setNormalColor(UIColor.darkGray, font: UIFont.systemFont(ofSize: 15.0))
        carbonTabSwipeNavigation.setTabBarHeight(50)
        
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(OriginalColors.primary.uiColor())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func Click_Close(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
       
        guard let storyboard = storyboard else { return UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "LoginFormViewController")
        }
        return storyboard.instantiateViewController(withIdentifier: "SignUpFormViewController")
    }
}

extension LoginViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage: Double = Double(scrollView.contentOffset.x / pageWidth)
        let page = Int(round(fractionalPage))
        if !isTabSelected {
            tab.selectedSegmentIndex = page
        }
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x == pageWidth {
            isTabSelected = false
        }
    }
    
    
}
