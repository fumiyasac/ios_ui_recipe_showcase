//
//  MainCollectionReusableHeaderView.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/16.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class MainCollectionReusableHeaderView: UICollectionReusableView {

    static let viewSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 64.0)

    var newsButtonTappedHandler: (() -> ())?

    @IBOutlet weak private var newsContentsButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupMainCollectionReusableHeaderView()
    }

    // MARK: - Private Function

    @objc private func newsContentsButtonTapped(sender: UIButton) {

        // ViewController側でクロージャー内にセットした処理を実行する
        newsButtonTappedHandler?()
    }

    private func setupMainCollectionReusableHeaderView() {

        // UIをコードで整えるための設定
        newsContentsButton.layer.masksToBounds = true
        newsContentsButton.layer.cornerRadius  = 5.0
        newsContentsButton.layer.borderColor   = UIColor(code: "#fd7f01").cgColor

        // ボタン押下時のアクションの設定
        newsContentsButton.addTarget(self, action:  #selector(self.newsContentsButtonTapped(sender:)), for: .touchUpInside)
    }
}
