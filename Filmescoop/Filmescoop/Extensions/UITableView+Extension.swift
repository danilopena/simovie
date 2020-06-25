//
//  UITableView+Extension.swift
//  Filmescoop
//
//  Created by Danilo Pena on 23/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }
    }
}
