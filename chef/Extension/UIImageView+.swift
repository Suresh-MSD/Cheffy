//
//  UIImageView+.swift
//  chef
//
//  Created by Eddie Ha on 23/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImageFromUrl(url:String){
        let imageUrl = URL(string: url)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "img_logo_red"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
