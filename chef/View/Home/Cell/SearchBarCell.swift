//
//  SearchBarCell.swift
//  chef
//
//  Created by Eddie Ha on 20/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

protocol SearchBarCellDelegate {

    func search(text: String)
    func stop_search()
}

class SearchBarCell: UICollectionViewCell {
    
    //MARK: Properties
    public let  CLASS_NAME = SearchBarCell.self.description()
    public var delegate: SearchBarCellDelegate?
    
    //MARK: Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var SerchButton: UIButton!
    
    @IBOutlet weak var FilterView: UIView!

    var sr = UISearchBar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        location = LocationService()
//        location.delegate = self
        searchTextField.delegate = self
        
        
        let disposer = DisposeBag()
        searchTextField.rx.text.orEmpty
        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [unowned self] (text) in
            self.delegate?.search(text: text)
        }).disposed(by: disposer)
        
    }
   
    @IBAction func SearchText(_ sender: UITextField) {
        
//        print(sender.text)
        
    }
}

extension SearchBarCell: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" {
            delegate?.stop_search()
        } else {
            delegate?.search(text: textField.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        delegate?.search(text: textField.text ?? "")
        return true
    }
}
