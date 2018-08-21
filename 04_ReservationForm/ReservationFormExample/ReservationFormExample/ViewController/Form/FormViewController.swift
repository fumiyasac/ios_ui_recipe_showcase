//
//  FormViewController.swift
//  ReservationFormExample
//
//  Created by 酒井文也 on 2018/08/20.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import KYNavigationProgress

class FormViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("予約情報の入力")
        setupKYNavigationProgress()
        setupNavigationCloseButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    @objc private func closeButtonTapped(_ sender: UIButton) {
        showCloseAlertWith(
            title: "このページから移動しますか？",
            message: "このページを離れると、入力したデータが削除されます。\n本当に移動しますか？",
            completionHandler: {
                self.dismiss(animated: true, completion: nil)
            }
        )
    }

    private func setupNavigationCloseButton() {

        // ナビゲーションバーの左側にボタンを配置する
        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.font]             = UIFont(name: "HiraKakuProN-W3", size: 13.0)
        attributes[NSAttributedStringKey.foregroundColor]  = UIColor.white

        let closeButton = UIBarButtonItem(title: "× 閉じる", style: .plain, target: self, action: #selector(self.closeButtonTapped(_:)))
        closeButton.tintColor = UIColor.white
        closeButton.setTitleTextAttributes(attributes, for: .normal)
        closeButton.setTitleTextAttributes(attributes, for: .highlighted)
        self.navigationItem.leftBarButtonItem = closeButton
    }

    // この画面のナビゲーションバー下アニメーションの設定
    private func setupKYNavigationProgress() {
        self.navigationController?.progress = 0.0
        self.navigationController?.progressTintColor = UIColor.init(code: "#44aeea", alpha: 1.0)
        self.navigationController?.trackTintColor    = UIColor.init(code: "#eeeeee", alpha: 1.0)
    }

    private func showCloseAlertWith(title: String, message: String, completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "このページにとどまる", style: .default, handler: { _ in
            completionHandler?()
        })
        alert.addAction(okAction)
        let ngAction = UIAlertAction(title: "このページから戻る", style: .default, handler: nil)
        alert.addAction(ngAction)
        self.present(alert, animated: true, completion: nil)
    }
}
