//
//  Food.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct Food {
    let id: Int
    let name: String
    let englishName: String
    let price: Int
    let rate: Float
    let imageFile: UIImage?

    // MARK: - Initializer

    init(id: Int, name: String, englishName: String, price: Int, rate: Float, imageName: String) {
        self.id          = id
        self.name        = name
        self.englishName = englishName
        self.price       = price
        self.rate        = rate
        self.imageFile   = UIImage(named: imageName)
    }
}
