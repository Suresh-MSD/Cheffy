//
//  UserProfileTabCell.swift
//  chef
//
//  Created by Eddie Ha on 28/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit


//MARK: Protocols
//UserProfileTabCellDelegate
protocol UserProfileTabCellDelegate:NSObjectProtocol {
    func onClickTabItem(position: Int, name: String, type: String)
}


class UserProfileTabCell: UICollectionViewCell {

    //MARK: Properties
    public let CLASS_NAME = UserProfileTabCell.self.description()
    open var delegate:UserProfileTabCellDelegate!
    
    //MARK: Outlets
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var uivTabBarIndicator: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    //MARK: Actions
    //when click on tab favorite
    @IBAction func onClickTabFavorite(_ sender: UIButton) {
        selectTab(tab: sender)
        
        if delegate != nil {
            delegate.onClickTabItem(position: 1, name: sender.title(for: .normal)!, type: "favorite")
        }
    }
    
    //when click on tab setting
    @IBAction func onClickTabSettings(_ sender: UIButton) {
        selectTab(tab: sender)
        
        if delegate != nil {
            delegate.onClickTabItem(position: 2, name: sender.title(for: .normal)!, type: "settings")
        }
    }
    
    
    //MARK: Instance Methods
    //select tab
    private func selectTab(tab:UIButton) -> Void {
        btnFavorite.setTitleColor(UIColor.darkGray, for: .normal)
        btnSettings.setTitleColor(UIColor.darkGray, for: .normal)
        
        tab.setTitleColor(UIColor.red, for: .normal)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.uivTabBarIndicator.frame = CGRect(x: tab.frame.origin.x, y: self.uivTabBarIndicator.frame.origin.y, width: tab.frame.width, height: self.uivTabBarIndicator.frame.height)
            self.layoutSubviews()
            self.layoutIfNeeded()
            
        })
    }
}
