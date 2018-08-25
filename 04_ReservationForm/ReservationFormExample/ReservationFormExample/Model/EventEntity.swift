//
//  EventEntity.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/25.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct EventEntity {
    let id: Int
    let photo: UIImage?
    let category: String
    let term: String
    let place: String
    let title: String
    let summary: String

    init(id: Int, imageName: String, category: String, term: String, place: String, title: String, summary: String) {
        self.id       = id
        self.photo    = UIImage(named: imageName)
        self.category = category
        self.term     = term
        self.place    = place
        self.title    = title
        self.summary  = summary
    }
}
