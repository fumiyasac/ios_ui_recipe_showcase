//
//  NewsViewController.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("ニュースコンテンツ")
        setupNavigationSettings()
        setupNavigationBarAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    @objc private func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    private func setupNavigationSettings() {

        // ナビゲーションバーの色を変更する
        self.navigationController?.navigationBar.barTintColor = UIColor(code: "#333333")
        self.navigationController?.navigationBar.isTranslucent = false

        // ナビゲーションバーの左側にボタンを配置する
        let closeButton = UIBarButtonItem(title: "× 閉じる", style: .plain, target: self, action: #selector(self.closeButtonTapped(_:)))
        closeButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = closeButton
    }

    // MEMO: このケースではUINavigationBarAppearance()の設定をまとめてではなく、個別に設定している
    private func setupNavigationBarAppearance() {

        // iOS15以降ではUINavigationBarの配色指定方法が変化する点に注意する
        // https://shtnkgm.com/blog/2021-08-18-ios15.html
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()

            // MEMO: UINavigationBar内部におけるタイトル文字の装飾設定
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.font : UIFont(name: "HiraKakuProN-W6", size: 14.0)!,
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]

            // MEMO: UINavigationBar背景色の装飾設定
            navigationBarAppearance.backgroundColor = UIColor(code: "#333333")

            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }

}
