//
//  State.swift
//  
//
//  Created by Danilo Pena on 19/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

enum State: Equatable {
    case success
    case failed(error: String)
}

