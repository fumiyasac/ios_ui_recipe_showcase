//
//  TravelModel.swift
//  LikeTinderExample
//
//  Created by 酒井文也 on 2018/08/19.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct TravelModel {

    let id: Int
    let title: String
    let image: UIImage
    let published: String
    let access: String
    let budget: String
    let message: String

    // MARK: - Initializer

    init(id: Int, title: String, imageName: String, published: String, access: String, budget: String, message: String) {
        self.id    = id
        self.title = title
        self.image = UIImage(named: imageName)!
        self.published = published
        self.access    = access
        self.budget    = budget
        self.message   = message
    }
}
