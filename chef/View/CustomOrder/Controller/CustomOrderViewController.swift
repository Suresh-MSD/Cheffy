//
//  CustomerViewController.swift
//  chef
//
//  Created by Eddie Ha on 10/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import ReSwift

class CustomOrderViewController: UIViewController {

    //MARK: Properties
    public let CLASS_NAME = CustomOrderViewController.self.description()
    
    //MARK: Outlets
    @IBOutlet weak var btnCustomOrder: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnCustomOrderItemOne: UIButton!
    @IBOutlet weak var btnCustomOrderItemTwo: UIButton!
    @IBOutlet weak var btnCustomOrderItemThree: UIButton!
    @IBOutlet weak var btnCustomOrderFour: UIButton!
    @IBOutlet weak var btnCustomOrderFive: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.subscribeStateUpdate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.unsubscribeStateUpdate()
    }
    
    //MARK: Actions
    //when click back button
    @IBAction func onTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //when click on custom order button
    @IBAction func onTapCustomOrderButton(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "PostCustomOrderViewController") as! PostCustomOrderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //when tap on croos button
    @IBAction func onTapCrossButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: Instance Method
    //initialize 
    private func initialize() -> Void{
        //shadows of buttons
        btnCustomOrder.elevate(elevation: 10, cornerRadius: 0, color: UIColor.red)
        btnCustomOrderItemOne.elevate(elevation: 10, cornerRadius: 0, color: ColorGenerator.UIColorFromHex(rgbValue: 0xEA1D2C, alpha: 0.6))
        btnCustomOrderItemTwo.elevate(elevation: 10, cornerRadius: 0, color: ColorGenerator.UIColorFromHex(rgbValue: 0xEA1D2C, alpha: 0.6))
        btnCustomOrderItemThree.elevate(elevation: 10, cornerRadius: 0, color: ColorGenerator.UIColorFromHex(rgbValue: 0xEA1D2C, alpha: 0.6))
        btnCustomOrderFour.elevate(elevation: 10, cornerRadius: 0, color: ColorGenerator.UIColorFromHex(rgbValue: 0xEA1D2C, alpha: 0.6))
        btnCustomOrderFive.elevate(elevation: 10, cornerRadius: 0, color: ColorGenerator.UIColorFromHex(rgbValue: 0xEA1D2C, alpha: 0.6))
    }
    
}

extension CustomOrderViewController: StoreSubscriber {
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
    }
}
