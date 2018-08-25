//
//  FormDataStore.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/21.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// フォームで入力された要素を一時的に格納する場所
// MEMO: 今回は特にDBへの登録処理等がないのでSingleton Instanceで保持する

class FormDataStore {

    var eventId: Int     = 0
    var ticketCount: Int = 0
    var name: String        = ""
    var address: String     = ""
    var telephone: String   = ""
    var mailaddress: String = ""
    var agreement: Bool         = false
    var allowTelephone: Bool    = false
    var allowMailMagazine: Bool = false

    // MARK: - Singleton Instance

    static var shared = FormDataStore()

    private init() {}

    // MARK: - Static Functions

    static func validate() -> Bool {

        if self.shared.eventId == 0 {
            return false
        }

        if self.shared.ticketCount == 0 {
            return false
        }

        if self.shared.name.isEmpty {
            return false
        }

        if self.shared.telephone.isEmpty || validTelephoneCountRange() == false {
            return false
        }

        if self.shared.mailaddress.isEmpty || validMailAddressFormat() == false {
            return false
        }

        if self.shared.agreement == false {
            return false
        }

        return true
    }

    static func deleteAll() {
        shared = FormDataStore()
    }

    // MARK: - Private Static Functions

    private static func validTelephoneCountRange() -> Bool {
        return (10...11 ~= self.shared.telephone.count)
    }

    private static func validMailAddressFormat() -> Bool {

        // 参考:
        // http://aryzae.hatenablog.com/entry/2017/12/13/004159
 
        // Eメールの正規表現
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"

        // MEMO: NSRegularExpressionを用いるのはアットマークの半角を正しく判定するため
        let regexp = try! NSRegularExpression.init(pattern: pattern, options: [])

        let mailaddress = self.shared.mailaddress
        let nsString = mailaddress as NSString

        let result = regexp.firstMatch(in: mailaddress, options: [], range: NSRange.init(location: 0, length: nsString.length))
        return (result != nil)
    }
}
