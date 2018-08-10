//
//  NSObjectProtocolExtension.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// NSObjectProtocolの拡張
extension NSObjectProtocol {
    
    // クラス名を返す変数"className"を返す
    static var className: String {
        return String(describing: self)
    }
}
