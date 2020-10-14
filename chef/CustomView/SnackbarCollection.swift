//
//  SnackbarCollection.swift
//  chef
//
//  Created by Eddie Ha on 24/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import  MaterialComponents

class SnackbarCollection {

    //show snack bar for text only
    public static func showSnackbarWithText(text:String) -> Void{
        let message = MDCSnackbarMessage()
        message.text = text
        MDCSnackbarManager.show(message)
    }
}
