//
//  UIViewControllerExtension.swift
//  LikeTinderExample
//
//  Created by 酒井文也 on 2018/08/19.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// UIViewControllerの拡張
extension UIViewController {

    // この画面のナビゲーションバーを設定するメソッド
    public func setupNavigationBarTitle(_ title: String) {

        // NavigationControllerのデザイン調整を行う
        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.font]             = UIFont(name: "HiraKakuProN-W6", size: 14.0)
        attributes[NSAttributedStringKey.foregroundColor]  = UIColor.white

        self.navigationController!.navigationBar.barTintColor        = UIColor(code: "#76b6e2")
        self.navigationController!.navigationBar.tintColor           = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = attributes

        // タイトルを入れる
        self.navigationItem.title = title
    }
}
