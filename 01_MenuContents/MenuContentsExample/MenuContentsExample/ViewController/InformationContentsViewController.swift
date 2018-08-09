//
//  InformationContentsViewController.swift
//  MenuContentsExample
//
//  Created by 酒井文也 on 2018/08/09.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class InformationContentsViewController: UIViewController {

    // メニュー用ハンバーガーボタン
    private var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // ナビゲーションバータイトルのデザイン調整を行う
        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.font]             = UIFont(name: "HiraKakuProN-W3", size: 14.0)
        attributes[NSAttributedStringKey.foregroundColor]  = UIColor.black

        self.navigationController!.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "お知らせコンテンツの画面"

        // メニューボタンを設置のデザイン調整を行う
        var menuAttributes = [NSAttributedStringKey : Any]()
        menuAttributes[NSAttributedStringKey.font]            = UIFont(name: "HiraKakuProN-W3", size: 30)
        menuAttributes[NSAttributedStringKey.foregroundColor] = UIColor.gray

        menuButton = UIBarButtonItem(title: "≡", style: .plain, target: self, action: #selector(self.menuButtonTapped(sender:)))
        menuButton.setTitleTextAttributes(menuAttributes, for: .normal)
        navigationItem.leftBarButtonItem = menuButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // BaseViewControllerのメソッドを呼び出して左側コンテンツを開く
    // このコントローラーはUINavigationControllerと繋がっているので、「ViewController(親) → UINavigationController(子) → ContentListViewController(孫)」の関係となるので下記のようにたどる
    @objc private func menuButtonTapped(sender: UIBarButtonItem) {
        if let parentViewController = self.parent?.parent {
            let vc = parentViewController as! BaseViewController
            vc.openSideNavigation()
        }
    }
}
