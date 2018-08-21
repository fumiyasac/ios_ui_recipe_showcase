//
//  UIViewControllerExtension.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/21.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// UIViewControllerの拡張
extension UIViewController {

    // この画面のナビゲーションバーを設定するメソッド
    func setupNavigationBarTitle(_ title: String) {

        // NavigationControllerのデザイン調整を行う
        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.font]             = UIFont(name: "HiraKakuProN-W6", size: 14.0)
        attributes[NSAttributedStringKey.foregroundColor]  = UIColor.white

        self.navigationController!.navigationBar.isTranslucent       = false
        self.navigationController!.navigationBar.barTintColor        = UIColor(code: "#6db5a9")
        self.navigationController!.navigationBar.titleTextAttributes = attributes

        // タイトルを入れる
        self.navigationItem.title = title
    }

    // 戻るボタンの「戻る」テキストを削除した状態にするメソッド
    func removeBackButtonText() {
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = backButtonItem
    }
}
