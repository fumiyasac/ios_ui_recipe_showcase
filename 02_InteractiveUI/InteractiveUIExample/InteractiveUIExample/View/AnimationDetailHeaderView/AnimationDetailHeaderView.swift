//
//  AnimationDetailHeaderView.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/17.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class AnimationDetailHeaderView: CustomViewBase {

    var headerBackButtonTappedHandler: (() -> ())?

    // 初期状態のheaderWrappedViewTopConstraintのマージン値（iPhoneX用に補正あり）
    private let defaultHeaderMargin: CGFloat = {
        return DeviceSize.iPhoneXCompatible() ? 44 : 20
    }()

    @IBOutlet weak private var headerBackgroundView: UIView!
    @IBOutlet weak private var headerWrappedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var headerTitle: UILabel!
    @IBOutlet weak private var headerBackButton: UIButton!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupAnimationDetailHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupAnimationDetailHeaderView()
    }

    // MARK: - Function

    // ダミーのヘッダー内にある背景Viewのアルファ値をセットする
    func setHeaderBackgroundViewAlpha(_ alpha: CGFloat) {
        headerBackgroundView.alpha = alpha
    }

    // ダミーのヘッダー内にあるタイトルをセットする
    func setTitle(_ title: String?) {
        headerTitle.text = title
    }

    // ダミーのヘッダー内の上方向の制約を更新する
    /* *
     * 引数「constraint」の算出方法について:
     * (画像のパララックス効果付きのViewの高さ) - (NavigationBarの高さを引いたもの) - (UIScrollView側のY軸方向のスクロール量)
    */
    func setHeaderNavigationTopConstraint(_ constant: CGFloat) {
        if constant > 0 {
            headerWrappedViewTopConstraint.constant = defaultHeaderMargin + constant
        } else {
            headerWrappedViewTopConstraint.constant = defaultHeaderMargin
        }
        self.layoutIfNeeded()
    }

    // MARK: - Private Function

    @objc private func headerBackButtonTapped(sender: UIButton) {

        // ViewController側でクロージャー内にセットした処理を実行する
        headerBackButtonTappedHandler?()
    }

    private func setupAnimationDetailHeaderView() {

        // ボタン押下時のアクションの設定
        headerBackButton.addTarget(self, action:  #selector(self.headerBackButtonTapped(sender:)), for: .touchUpInside)
    }
}
