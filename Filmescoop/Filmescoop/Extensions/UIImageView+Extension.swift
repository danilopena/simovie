//
//  UIImageView+Extension.swift
//  Filmescoop
//
//  Created by Danilo Pena on 24/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

extension UIImageView {
    func blurred() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
