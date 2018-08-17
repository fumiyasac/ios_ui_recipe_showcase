//
//  DeviceSize.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/17.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct DeviceSize {

    // iPhoneXのサイズに対応しているかを返す
    static func iPhoneXCompatible() -> Bool {
        return (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0)
    }
}
