//
//  FormTypes.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/23.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation

// フォームの用途を定義したenum

// テキストフィールドの種類
enum TextFieldType {
    case inputName
    case inputAddress
    case inputTelephone
    case inputMailaddress

    func getTag() -> Int {
        switch self {
        case .inputName:
            return 1
        case .inputAddress:
            return 2
        case .inputTelephone:
            return 3
        case .inputMailaddress:
            return 4
        }
    }
}

// スイッチの種類
enum SwitchType {
    case agreement
    case allowTelephone
    case allowMailMagazine

    func getTag() -> Int {
        switch self {
        case .agreement:
            return 1
        case .allowTelephone:
            return 2
        case .allowMailMagazine:
            return 3
        }
    }
}
