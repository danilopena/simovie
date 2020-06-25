//
//  UIViewController+Extensions.swift
//  
//
//  Created by Danilo Pena on 19/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(with title: String, message: String, titleButton: String = "OK") {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: titleButton, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }

}
