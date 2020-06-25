//
//  UIResponder+Extension.swift
//  Filmescoop
//
//  Created by Danilo Pena on 21/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

extension UIResponder {
    func navigationStyle() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        UIBarButtonItem.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = true
    }
}
