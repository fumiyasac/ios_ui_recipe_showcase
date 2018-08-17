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
}
