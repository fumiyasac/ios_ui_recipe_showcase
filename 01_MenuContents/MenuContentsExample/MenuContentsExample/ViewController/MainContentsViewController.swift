//
//  MainContentsViewController.swift
//  MenuContentsExample
//
//  Created by 酒井文也 on 2018/08/09.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class MainContentsViewController: UIViewController {

    // メニュー用ハンバーガーボタン
    private var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // ナビゲーションバータイトルのデザイン調整を行う
        var titleAttributes = [NSAttributedString.Key : Any]()
        titleAttributes[NSAttributedString.Key.font]            = UIFont(name: "HiraKakuProN-W3", size: 14.0)
        titleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black

        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes
        self.navigationItem.title = "メインコンテンツの画面"

        // メニューボタンを設置のデザイン調整を行う
        var menuAttributes = [NSAttributedString.Key : Any]()
        menuAttributes[NSAttributedString.Key.font]            = UIFont(name: "HiraKakuProN-W3", size: 30)
        menuAttributes[NSAttributedString.Key.foregroundColor] = UIColor.gray

        menuButton = UIBarButtonItem(title: "≡", style: .plain, target: self, action: #selector(self.menuButtonTapped(sender:)))
        menuButton.setTitleTextAttributes(menuAttributes, for: .normal)
        navigationItem.leftBarButtonItem = menuButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function
    
    // サイドナビゲーションが閉じた状態から左隅のドラッグを行ってコンテンツを開く際の処理
    @objc private func menuButtonTapped(sender: UIBarButtonItem) {

        // BaseViewControllerのメソッドを呼び出して左側コンテンツを開く
        // このコントローラーはUINavigationControllerと繋がっているので、「ViewController(親) → UINavigationController(子) → ContentListViewController(孫)」の関係となるので下記のようにたどる
        if let parentViewController = self.parent?.parent {
            let vc = parentViewController as! BaseViewController
            vc.openSideNavigation()
        }
    }
}
